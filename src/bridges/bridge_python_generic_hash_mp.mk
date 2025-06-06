
PYTHON_CFLAGS     := `python3-config --includes`
# See BUILD_WSL.md how to prepare $(WIN_PYTHON)
PYTHON_CFLAGS_WIN := -I$(WIN_PYTHON)/mingw64/include/python3.12/

ifeq ($(BUILD_MODE),cross)
bridges/bridge_python_generic_hash_mp.so:  src/bridges/bridge_python_generic_hash_mp.c src/cpu_features.c obj/combined.LINUX.a
	$(CC_LINUX)  $(CCFLAGS) $(CFLAGS_CROSS_LINUX) $^ -o $@ $(LFLAGS_CROSS_LINUX) -shared -fPIC -D BRIDGE_INTERFACE_VERSION_CURRENT=$(BRIDGE_INTERFACE_VERSION) $(PYTHON_CFLAGS)
bridges/bridge_python_generic_hash_mp.dll: src/bridges/bridge_python_generic_hash_mp.c src/cpu_features.c obj/combined.WIN.a
	$(CC_WIN)    $(CCFLAGS) $(CFLAGS_CROSS_WIN)   $^ -o $@ $(LFLAGS_CROSS_WIN)   -shared -fPIC -D BRIDGE_INTERFACE_VERSION_CURRENT=$(BRIDGE_INTERFACE_VERSION) $(PYTHON_CFLAGS_WIN)
else
ifeq ($(SHARED),1)
bridges/bridge_python_generic_hash_mp.$(BRIDGE_SUFFIX): src/bridges/bridge_python_generic_hash_mp.c src/cpu_features.c $(HASHCAT_LIBRARY)
	$(CC)       $(CCFLAGS) $(CFLAGS_NATIVE)       $^ -o $@ $(LFLAGS_NATIVE)      -shared -fPIC -D BRIDGE_INTERFACE_VERSION_CURRENT=$(BRIDGE_INTERFACE_VERSION) $(PYTHON_CFLAGS)
else
bridges/bridge_python_generic_hash_mp.$(BRIDGE_SUFFIX): src/bridges/bridge_python_generic_hash_mp.c src/cpu_features.c obj/combined.NATIVE.a
	$(CC)       $(CCFLAGS) $(CFLAGS_NATIVE)       $^ -o $@ $(LFLAGS_NATIVE)      -shared -fPIC -D BRIDGE_INTERFACE_VERSION_CURRENT=$(BRIDGE_INTERFACE_VERSION) $(PYTHON_CFLAGS)
endif
endif
