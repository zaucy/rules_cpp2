load("@rules_cc//cc:defs.bzl", "cc_binary", "cc_library", "cc_test")

def _cppfront_impl(ctx):
    outputs = []

    for src in ctx.files.srcs:
        cpp_file = ctx.actions.declare_file(src.path[:-4] + "cpp")
        args = ctx.actions.args()
        args.add(src)

        # args.add("-p")
        args.add("-o", cpp_file)

        ctx.actions.run(
            outputs = [cpp_file],
            executable = ctx.file._cppfront_tool,
            arguments = [args],
            inputs = [src],
            tools = [ctx.file._cppfront_tool],
            mnemonic = "Cppfront",
            progress_message = "Transpiling %{input} to %{output}",
        )

        outputs.append(cpp_file)

    for src in ctx.files.srcs:
        h_file = ctx.actions.declare_file(src.path[:-4] + "h")
        args = ctx.actions.args()
        args.add(src)

        # args.add("-p")
        args.add("-o", h_file)

        ctx.actions.run(
            outputs = [h_file],
            executable = ctx.file._cppfront_tool,
            arguments = [args],
            inputs = [src],
            tools = [ctx.file._cppfront_tool],
            mnemonic = "Cppfront",
            progress_message = "Transpiling %{input} to %{output}",
        )

        outputs.append(h_file)

    return [
        DefaultInfo(files = depset(outputs)),
    ]

_cppfront = rule(
    implementation = _cppfront_impl,
    attrs = {
        "srcs": attr.label_list(
            allow_empty = False,
            mandatory = True,
            allow_files = [".cpp2"],
        ),
        "_cppfront_tool": attr.label(
            default = Label("@cppfront//:cppfront"),
            allow_single_file = True,
            cfg = "exec",
        ),
    },
)

_CPP2_DEFAULT_DEPS = [
    "@cppfront//:cpp2util",
]

_MSVC_COPTS = [
    "/std:c++20",
    "/EHsc",
]

_CPP2_DEFAULT_COPTS = select({
    "@bazel_tools//tools/cpp:msvc": _MSVC_COPTS,
    "@bazel_tools//src/conditions:windows": _MSVC_COPTS,
    "@bazel_tools//src/conditions:windows_msvc": _MSVC_COPTS,
    "//conditions:default": [
        "-std=c++20",
    ],
})

def cpp2_library(name = None, srcs = None, deps = [], copts = [], **kwargs):
    srcs_target_name = "{}__cppfront_srcs".format(name)
    _cppfront(
        name = srcs_target_name,
        srcs = srcs,
    )
    cc_library(
        name = name,
        srcs = [srcs_target_name],
        deps = _CPP2_DEFAULT_DEPS + deps,
        copts = _CPP2_DEFAULT_COPTS + copts,
        **kwargs
    )

def cpp2_binary(name = None, srcs = None, deps = [], copts = [], **kwargs):
    srcs_target_name = "{}__cppfront_srcs".format(name)
    _cppfront(
        name = srcs_target_name,
        srcs = srcs,
    )
    cc_binary(
        name = name,
        srcs = [srcs_target_name],
        deps = _CPP2_DEFAULT_DEPS + deps,
        copts = _CPP2_DEFAULT_COPTS + copts,
        **kwargs
    )

def cpp2_test(name = None, srcs = None, deps = [], copts = [], **kwargs):
    srcs_target_name = "{}__cppfront_srcs".format(name)
    _cppfront(
        name = srcs_target_name,
        srcs = srcs,
    )
    cc_test(
        name = name,
        srcs = [srcs_target_name],
        deps = _CPP2_DEFAULT_DEPS + deps,
        copts = _CPP2_DEFAULT_COPTS + copts,
        **kwargs
    )
