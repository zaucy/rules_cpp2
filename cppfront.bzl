load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def _impl(mctx):
    http_archive(
        name = "cppfront",
        url = "https://github.com/hsutter/cppfront/archive/refs/heads/main.zip",
        strip_prefix = "cppfront-main",
        build_file = Label("@rules_cpp2//:BUILD.cppfront.bazel"),
    )

cppfront_repo = module_extension(
    implementation = _impl,
)
