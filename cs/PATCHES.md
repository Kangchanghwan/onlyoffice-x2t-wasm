# Changes relative to cryptpad/onlyoffice-x2t-wasm 17bd0351

core/ was replaced wholesale with ONLYOFFICE core ed63e94 (the previous core/ was Euro-Office 9.3.2 based). The CryptPad edits marked "CryptPad:" were re-applied by hand to these files:

- core/Common/3dParty/boost/boost.pri: do not link boost_regex
- core/Common/3dParty/html/css/CssCalculator.pri: build without Qt UI
- core/Common/3dParty/icu/icu.pri: no icu libs, emscripten has its own
- core/Common/base.pri: drop --disable-new-dtags; set clang_no_exclude_libs (wasm-ld has no --exclude-libs) [new in 10.0]
- core/UnicodeConverter/UnicodeConverter.pro: drop --disable-new-dtags
- core/Common/kernel.pro: no build_zlib_as_sources (duplicate symbols), do not link UnicodeConverter
- core/DesktopEditor/graphics/pro/freetype.pri, raster.pri: zlib sources commented out (duplicate symbols)
- core/DesktopEditor/graphics/pro/textshaper.pri: keep shaper enabled
- core/Fb2File/Fb2File.pro, core/PdfFile/PdfFile.pro: do not link dependencies/CryptoPPLib here
- core/OfficeUtils/OfficeUtils.pri: drop miniunz.c/minizip.c (they define main)
- core/DesktopEditor/doctrenderer/js_internal/js_base.pri: no JS engine
- core/DesktopEditor/doctrenderer/doctrenderer.pri: only stub sources; drawingfile.cpp added (defines CDrawingFile::m_sCMapFolder)
- core/DesktopEditor/doctrenderer/{doctrenderer,docbuilder,docbuilder_p}_empty.cpp: CryptPad stubs copied from 17bd0351
- core/X2tConverter/src/main.cpp: no proclimits.h / limit_memory
- core/X2tConverter/src/lib/pdf_image.h: pdf.bin from workdir (doct_bin2pdf)
- core/X2tConverter/build/Qt/X2tConverter.pri: link list without Fb2File/ooxmlsignature; adds OFDFile, StarMathConverter (new in 10.0)
- core/Common/Network/network.pro: LOCAL IPC (asio) block commented out [new in 10.0]

Outside core/:

- Dockerfile: build_tools v10.0.0.176; boost from release tarball; new stages libxml, ofdfile, starmath; libxml overlay in every stage that copies DesktopEditor; Common copied in unicodeconverter and no mv of the .a; header modules copied in doctrenderer; build split into build-libs/build; reference documentserver stage removed (test.js does not use it)
- embuild.sh: -w and -include float.h in CFLAGS
- build.sh: no podman flags when docker exists; DOCKER_BUILD_EXTRA hook
- .github/workflows/cs-build.yml: CI build + release
- cs/*: notes, patches, upstream.json
