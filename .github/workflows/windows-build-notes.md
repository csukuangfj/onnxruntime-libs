```
runneradmin@runnervmxfv8o MINGW64 /d/a/onnxruntime-libs/onnxruntime-libs
# ls
build             CITATION.cff     csharp       js            onnxruntime                pyproject.toml        requirements-lintrunner.txt  setup.py
build.bat         cmake            dockerfiles  lgtm.yml      ort.wprp                   README.md             requirements-training.txt    ThirdPartyNotices.txt
build.sh          CODEOWNERS       docs         LICENSE       ORT_icon_for_light_bg.png  requirements.txt      rust                         tools
build_arm64x.bat  CONTRIBUTING.md  include      NuGet.config  orttraining                requirements-dev.txt  samples                      VERSION_NUMBER
cgmanifests       CPPLINT.cfg      java         objectivec    packages.config            requirements-doc.txt  SECURITY.md                  winml


runneradmin@runnervmxfv8o MINGW64 /d/a/onnxruntime-libs/onnxruntime-libs
# cd build

runneradmin@runnervmxfv8o MINGW64 /d/a/onnxruntime-libs/onnxruntime-libs/build
# ls
windows_x64

# cd windows_x64/

runneradmin@runnervmxfv8o MINGW64 /d/a/onnxruntime-libs/onnxruntime-libs/build/windows_x64
# ls
Release

# cd Release/

runneradmin@runnervmxfv8o MINGW64 /d/a/onnxruntime-libs/onnxruntime-libs/build/windows_x64/Release

# ls Release/
custom_op_get_const_input_test_library.dll  onnx_test_runner.exe                       onnxruntime_graph.pdb              onnxruntime_providers_shared.lib
custom_op_get_const_input_test_library.exp  onnx_test_runner_common.lib                onnxruntime_logging_apis_test.exe  onnxruntime_session.lib
custom_op_get_const_input_test_library.lib  onnx_test_runner_common.pdb                onnxruntime_lora.lib               onnxruntime_session.pdb
custom_op_invalid_library.dll               onnxruntime.dll                            onnxruntime_lora.pdb               onnxruntime_shared_lib_dlopen_test.exe
custom_op_invalid_library.exp               onnxruntime.exp                            onnxruntime_mlas.lib               onnxruntime_shared_lib_test.exe
custom_op_invalid_library.lib               onnxruntime.lib                            onnxruntime_mlas.pdb               onnxruntime_test_all.exe
custom_op_library.dll                       onnxruntime_autoep_test.exe                onnxruntime_mlas_q4dq.exe          onnxruntime_test_utils.lib
custom_op_library.exp                       onnxruntime_common.lib                     onnxruntime_mlas_test.exe          onnxruntime_test_utils.pdb
custom_op_library.lib                       onnxruntime_common.pdb                     onnxruntime_mocked_allocator.lib   onnxruntime_util.lib
custom_op_local_function.dll                onnxruntime_customopregistration_test.exe  onnxruntime_mocked_allocator.pdb   onnxruntime_util.pdb
custom_op_local_function.exp                onnxruntime_ep_graph_test.exe              onnxruntime_optimizer.lib          samples
custom_op_local_function.lib                onnxruntime_flatbuffers.lib                onnxruntime_optimizer.pdb          test_execution_provider.dll
example_plugin_ep.dll                       onnxruntime_flatbuffers.pdb                onnxruntime_perf_test.exe          test_execution_provider.exp
example_plugin_ep.exp                       onnxruntime_framework.lib                  onnxruntime_providers.lib          test_execution_provider.lib
example_plugin_ep.lib                       onnxruntime_framework.pdb                  onnxruntime_providers.pdb          testdata
onnx_test_data_proto.lib                    onnxruntime_global_thread_pools_test.exe   onnxruntime_providers_shared.dll   win_getopt_wide.lib
onnx_test_data_proto.pdb                    onnxruntime_graph.lib                      onnxruntime_providers_shared.exp   win_getopt_wide.pdb

# pwd
/d/a/onnxruntime-libs/onnxruntime-libs/build/windows_x64/Release/Release

custom_op_get_const_input_test_library.dll  onnx_test_runner.exe                       onnxruntime_graph.pdb              onnxruntime_providers_shared.lib
custom_op_get_const_input_test_library.exp  onnx_test_runner_common.lib                onnxruntime_logging_apis_test.exe  onnxruntime_session.lib
custom_op_get_const_input_test_library.lib  onnx_test_runner_common.pdb                onnxruntime_lora.lib               onnxruntime_session.pdb
custom_op_invalid_library.dll               onnxruntime.dll                            onnxruntime_lora.pdb               onnxruntime_shared_lib_dlopen_test.exe
custom_op_invalid_library.exp               onnxruntime.exp                            onnxruntime_mlas.lib               onnxruntime_shared_lib_test.exe
custom_op_invalid_library.lib               onnxruntime.lib                            onnxruntime_mlas.pdb               onnxruntime_test_all.exe
custom_op_library.dll                       onnxruntime_autoep_test.exe                onnxruntime_mlas_q4dq.exe          onnxruntime_test_utils.lib
custom_op_library.exp                       onnxruntime_common.lib                     onnxruntime_mlas_test.exe          onnxruntime_test_utils.pdb
custom_op_library.lib                       onnxruntime_common.pdb                     onnxruntime_mocked_allocator.lib   onnxruntime_util.lib
custom_op_local_function.dll                onnxruntime_customopregistration_test.exe  onnxruntime_mocked_allocator.pdb   onnxruntime_util.pdb
custom_op_local_function.exp                onnxruntime_ep_graph_test.exe              onnxruntime_optimizer.lib          samples
custom_op_local_function.lib                onnxruntime_flatbuffers.lib                onnxruntime_optimizer.pdb          test_execution_provider.dll
example_plugin_ep.dll                       onnxruntime_flatbuffers.pdb                onnxruntime_perf_test.exe          test_execution_provider.exp
example_plugin_ep.exp                       onnxruntime_framework.lib                  onnxruntime_providers.lib          test_execution_provider.lib
example_plugin_ep.lib                       onnxruntime_framework.pdb                  onnxruntime_providers.pdb          testdata
onnx_test_data_proto.lib                    onnxruntime_global_thread_pools_test.exe   onnxruntime_providers_shared.dll   win_getopt_wide.lib
onnx_test_data_proto.pdb                    onnxruntime_graph.lib                      onnxruntime_providers_shared.exp   win_getopt_wide.pdb


# ls -lh
total 2.1G
-rwxr-xr-x 1 runneradmin None  130K Jan 29 13:39 custom_op_get_const_input_test_library.dll
-rw-r--r-- 1 runneradmin None  1.2K Jan 29 13:39 custom_op_get_const_input_test_library.exp
-rw-r--r-- 1 runneradmin None  2.2K Jan 29 13:39 custom_op_get_const_input_test_library.lib
-rwxr-xr-x 1 runneradmin None  102K Jan 29 13:39 custom_op_invalid_library.dll
-rw-r--r-- 1 runneradmin None  1.1K Jan 29 13:39 custom_op_invalid_library.exp
-rw-r--r-- 1 runneradmin None  2.1K Jan 29 13:39 custom_op_invalid_library.lib
-rwxr-xr-x 1 runneradmin None  208K Jan 29 14:12 custom_op_library.dll
-rw-r--r-- 1 runneradmin None  1.2K Jan 29 14:12 custom_op_library.exp
-rw-r--r-- 1 runneradmin None  2.2K Jan 29 14:12 custom_op_library.lib
-rwxr-xr-x 1 runneradmin None  132K Jan 29 13:39 custom_op_local_function.dll
-rw-r--r-- 1 runneradmin None  1.1K Jan 29 13:39 custom_op_local_function.exp
-rw-r--r-- 1 runneradmin None  2.0K Jan 29 13:39 custom_op_local_function.lib
-rwxr-xr-x 1 runneradmin None  351K Jan 29 14:12 example_plugin_ep.dll
-rw-r--r-- 1 runneradmin None  1.2K Jan 29 14:12 example_plugin_ep.exp
-rw-r--r-- 1 runneradmin None  2.2K Jan 29 14:12 example_plugin_ep.lib
-rw-r--r-- 1 runneradmin None  6.8M Jan 29 14:12 onnx_test_data_proto.lib
-rw-r--r-- 1 runneradmin None  1.9M Jan 29 14:12 onnx_test_data_proto.pdb
-rwxr-xr-x 1 runneradmin None   15M Jan 29 14:14 onnx_test_runner.exe
-rw-r--r-- 1 runneradmin None   22M Jan 29 14:13 onnx_test_runner_common.lib
-rw-r--r-- 1 runneradmin None  6.5M Jan 29 14:13 onnx_test_runner_common.pdb
-rwxr-xr-x 1 runneradmin None   15M Jan 29 14:12 onnxruntime.dll
-rw-r--r-- 1 runneradmin None  1.2K Jan 29 14:12 onnxruntime.exp
-rw-r--r-- 1 runneradmin None  2.1K Jan 29 14:12 onnxruntime.lib

-rwxr-xr-x 1 runneradmin None   15M Jan 29 14:15 onnxruntime_autoep_test.exe
-rw-r--r-- 1 runneradmin None   30M Jan 29 13:55 onnxruntime_common.lib
-rw-r--r-- 1 runneradmin None  4.8M Jan 29 13:55 onnxruntime_common.pdb
-rwxr-xr-x 1 runneradmin None  1.1M Jan 29 14:14 onnxruntime_customopregistration_test.exe
-rwxr-xr-x 1 runneradmin None   15M Jan 29 14:14 onnxruntime_ep_graph_test.exe
-rw-r--r-- 1 runneradmin None  2.4M Jan 29 13:46 onnxruntime_flatbuffers.lib
-rw-r--r-- 1 runneradmin None  3.0M Jan 29 13:46 onnxruntime_flatbuffers.pdb
-rw-r--r-- 1 runneradmin None  188M Jan 29 13:58 onnxruntime_framework.lib
-rw-r--r-- 1 runneradmin None   24M Jan 29 13:58 onnxruntime_framework.pdb
-rwxr-xr-x 1 runneradmin None  981K Jan 29 14:13 onnxruntime_global_thread_pools_test.exe
-rw-r--r-- 1 runneradmin None  123M Jan 29 13:51 onnxruntime_graph.lib
-rw-r--r-- 1 runneradmin None   18M Jan 29 13:51 onnxruntime_graph.pdb
-rwxr-xr-x 1 runneradmin None  1.1M Jan 29 14:13 onnxruntime_logging_apis_test.exe
-rw-r--r-- 1 runneradmin None  2.0M Jan 29 13:46 onnxruntime_lora.lib
-rw-r--r-- 1 runneradmin None  3.0M Jan 29 13:46 onnxruntime_lora.pdb
-rw-r--r-- 1 runneradmin None   23M Jan 29 13:44 onnxruntime_mlas.lib
-rw-r--r-- 1 runneradmin None  2.6M Jan 29 13:43 onnxruntime_mlas.pdb
-rwxr-xr-x 1 runneradmin None 1023K Jan 29 14:12 onnxruntime_mlas_q4dq.exe
-rwxr-xr-x 1 runneradmin None  4.1M Jan 29 14:17 onnxruntime_mlas_test.exe
-rw-r--r-- 1 runneradmin None  1.1M Jan 29 14:12 onnxruntime_mocked_allocator.lib
-rw-r--r-- 1 runneradmin None  1.2M Jan 29 14:12 onnxruntime_mocked_allocator.pdb
-rw-r--r-- 1 runneradmin None  249M Jan 29 14:02 onnxruntime_optimizer.lib
-rw-r--r-- 1 runneradmin None   24M Jan 29 14:02 onnxruntime_optimizer.pdb
-rwxr-xr-x 1 runneradmin None  1.5M Jan 29 14:15 onnxruntime_perf_test.exe
-rw-r--r-- 1 runneradmin None  807M Jan 29 14:11 onnxruntime_providers.lib
-rw-r--r-- 1 runneradmin None  211M Jan 29 14:11 onnxruntime_providers.pdb
-rwxr-xr-x 1 runneradmin None  103K Jan 29 13:41 onnxruntime_providers_shared.dll
-rw-r--r-- 1 runneradmin None  1.1K Jan 29 13:41 onnxruntime_providers_shared.exp
-rw-r--r-- 1 runneradmin None  2.3K Jan 29 13:41 onnxruntime_providers_shared.lib
-rw-r--r-- 1 runneradmin None  147M Jan 29 13:55 onnxruntime_session.lib
-rw-r--r-- 1 runneradmin None   24M Jan 29 13:55 onnxruntime_session.pdb
-rwxr-xr-x 1 runneradmin None  271K Jan 29 14:13 onnxruntime_shared_lib_dlopen_test.exe
-rwxr-xr-x 1 runneradmin None  2.0M Jan 29 14:15 onnxruntime_shared_lib_test.exe
-rwxr-xr-x 1 runneradmin None   37M Jan 29 14:41 onnxruntime_test_all.exe
-rw-r--r-- 1 runneradmin None   18M Jan 29 14:13 onnxruntime_test_utils.lib
-rw-r--r-- 1 runneradmin None   13M Jan 29 14:13 onnxruntime_test_utils.pdb
-rw-r--r-- 1 runneradmin None   32M Jan 29 13:47 onnxruntime_util.lib
-rw-r--r-- 1 runneradmin None   41M Jan 29 13:47 onnxruntime_util.pdb
drwxr-xr-x 1 runneradmin None     0 Jan 29 14:13 samples

-rwxr-xr-x 1 runneradmin None  292K Jan 29 13:57 test_execution_provider.dll
-rw-r--r-- 1 runneradmin None  1.1K Jan 29 13:57 test_execution_provider.exp
-rw-r--r-- 1 runneradmin None  2.2K Jan 29 13:57 test_execution_provider.lib
drwxr-xr-x 1 runneradmin None     0 Jan 29 14:13 testdata
-rw-r--r-- 1 runneradmin None   14K Jan 29 14:12 win_getopt_wide.lib
-rw-r--r-- 1 runneradmin None   76K Jan 29 14:12 win_getopt_wide.pdb

```


