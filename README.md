# rules_cpp2

Experimental [bazel](https://bazel.build/) rules for creating [cpp2](https://github.com/hsutter/cppfront) binaries and libraries.

See [examples](examples) folder for how your [BUILD.bazel](examples/BUILD.bazel) and [MODULE.bazel](examples/MODULE.bazel) files can be written.

## Notes

* cppfront is not ran in pure mode (`-p`) because [C++ 20 modules aren't supported in bazel yet](https://github.com/bazelbuild/bazel/issues/4005). Enabling the pure mode flag causes the following error:
  > [Fatal Error C1011](https://learn.microsoft.com/en-us/cpp/error-messages/compiler-errors-1/fatal-error-c1011?view=msvc-170): cannot locate standard module interface. Did you install the library part of the C++ modules feature in VS setup?
* The bazel extension repository for `@cppfront` points to the `main` branch since `cppfront` is under heavy development
