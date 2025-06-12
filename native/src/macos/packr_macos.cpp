#include <CoreFoundation/CoreFoundation.h>
#include <dlfcn.h>
#include <pthread.h>
#include <stdlib.h>
#include <sys/param.h>
#include <unistd.h>

#include <iostream>

#include "../packr.h"

using namespace std;

const char __CLASS_PATH_DELIM = ':';

void sourceCallBack(void* info) {}

static LaunchJavaVMDelegate s_delegate = NULL;
void* launchVM(void* param) {
    s_delegate();
    return nullptr;
}

int main(int argc, char** argv) {
    if (!setCmdLineArguments(argc, argv)) {
        return EXIT_FAILURE;
    }

    launchJavaVM([](LaunchJavaVMDelegate delegate, const JavaVMInitArgs& args) {
        for (jint arg = 0; arg < args.nOptions; arg++) {
            const char* optionString = args.options[arg].optionString;
            if (strcmp("-XstartOnFirstThread", optionString) == 0) {
                delegate();
                return;
            }
        }

        s_delegate = delegate;

        CFRunLoopSourceContext sourceContext;
        pthread_t vmthread;
        struct rlimit limit;
        size_t stack_size = 0;
        int rc = getrlimit(RLIMIT_STACK, &limit);
        if (rc == 0 && limit.rlim_cur != 0LL) {
            stack_size = (size_t)limit.rlim_cur;
        }

        pthread_attr_t thread_attr;
        pthread_attr_init(&thread_attr);
        pthread_attr_setscope(&thread_attr, PTHREAD_SCOPE_SYSTEM);
        pthread_attr_setdetachstate(&thread_attr, PTHREAD_CREATE_DETACHED);
        if (stack_size > 0) {
            pthread_attr_setstacksize(&thread_attr, stack_size);
        }
        pthread_create(&vmthread, &thread_attr, launchVM, 0);
        pthread_attr_destroy(&thread_attr);

        sourceContext.version = 0;
        sourceContext.perform = &sourceCallBack;

        CFRunLoopSourceRef sourceRef = CFRunLoopSourceCreate(NULL, 0, &sourceContext);
        CFRunLoopAddSource(CFRunLoopGetCurrent(), sourceRef, kCFRunLoopCommonModes);
        CFRunLoopRun();
    });

    return 0;
}

bool loadJNIFunctions(GetDefaultJavaVMInitArgs* getDefaultJavaVMInitArgs, CreateJavaVM* createJavaVM) {
    char resourcePath[MAXPATHLEN] = {0};
    CFBundleRef bundle = CFBundleGetMainBundle();
    if (bundle != NULL) {
        CFURLRef resourcesURL = CFBundleCopyResourcesDirectoryURL(bundle);
        if (resourcesURL != NULL) {
            CFURLGetFileSystemRepresentation(resourcesURL, true, (UInt8*)resourcePath, sizeof(resourcePath));
            CFRelease(resourcesURL);
        }
    }

    if (strlen(resourcePath) == 0) {
        cerr << "Failed to locate Resources directory." << endl;
        return false;
    }

    string libjliPath = string(resourcePath) + "/jre/lib/libjli.dylib";
    void* handle = dlopen(libjliPath.c_str(), RTLD_LAZY);
    if (handle == NULL) {
        cerr << "Failed to load libjli.dylib: " << dlerror() << endl;
        return false;
    }

    *getDefaultJavaVMInitArgs = (GetDefaultJavaVMInitArgs)dlsym(handle, "JNI_GetDefaultJavaVMInitArgs");
    *createJavaVM = (CreateJavaVM)dlsym(handle, "JNI_CreateJavaVM");

    if (!*getDefaultJavaVMInitArgs || !*createJavaVM) {
        cerr << "Failed to load JNI symbols: " << dlerror() << endl;
        return false;
    }

    return true;
}

// Optional: keep these if you need the other packr callbacks
extern "C" {
int _NSGetExecutablePath(char* buf, uint32_t* bufsize);
}

const char* getExecutablePath(const char* argv0) {
    static char buf[MAXPATHLEN];
    uint32_t size = sizeof(buf);
    if (_NSGetExecutablePath(buf, &size) == 0) {
        return buf;
    }
    return argv0;
}

bool changeWorkingDir(const char* directory) { return chdir(directory) == 0; }
void packrSetEnv(const char* key, const char* value) { setenv(key, value, 1); }