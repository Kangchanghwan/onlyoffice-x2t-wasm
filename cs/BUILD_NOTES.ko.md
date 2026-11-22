# 빌드 기록 (10.0)

- 시작: cs/main 에서 cs/x2t-10.0 브랜치를 만들고 core/ 를 ONLYOFFICE core ed63e94 로 교체했다.
- 현재 core/ 는 Euro-Office 9.3.2 기반이라서 ONLYOFFICE 원본과 줄 단위로 다르다. 그래서 subtree pull 대신 원본 트리를 통째로 넣고, CryptPad 표시("CryptPad:") 가 붙은 수정만 다시 적용했다.

## 시도 1 (run 45023514222)
- 실패: `unknown flag: --jobs`. 러너에 podman 이 같이 깔려 있어서 build.sh 가 podman 용 옵션을 docker 에도 넘겼다.
- 수정: docker 가 있으면 PARAMS 를 비우도록 build.sh 를 고쳤다.

## 시도 2 (run 45023761459)
- 실패: `Common` 단계에서 `No rule to make target '/core/Common/3dParty/libxml/libxml2/HTMLparser.c'`. 10.0 에서는 libxml2 가 core 안에 없고 `Common/3dParty/libxml/fetch.py` 로 GNOME 저장소에서 받아야 한다.
- 또 `unicodeconverter` 단계에서 `Cannot read /core/Common/base.pri`. 10.0 의 UnicodeConverter.pro 가 Common/base.pri 를 include 한다.
- 수정: `libxml` 단계를 새로 만들고 DesktopEditor 를 복사하는 모든 단계에 libxml 을 덮어 복사하게 했다. unicodeconverter 단계에 core/Common 복사를 추가했다.

## 시도 3 (run 45024680030)
- 실패: unicodeconverter 단계의 `mv /core/UnicodeConverter.o ...: No such file`. 10.0 에서는 base.pri 덕분에 libUnicodeConverter.a 가 build/lib/linux_64 에 바로 생긴다.
- 수정: 그 mv 줄을 지웠다. (libxml, base.pri 문제는 이번에 해결됐고 약 10분 만에 이 단계까지 도달)

## 시도 4 (run 45025616217)
- 실패: `OOXML/Projects/Linux/DocxFormatLib` 단계에서 make 가 2로 종료됐는데, 경고가 너무 많아 로그가 2MiB 제한으로 잘려서 실제 오류 줄이 안 보였다.
- 수정: embuild.sh 의 CFLAGS 에 `-w` 를 넣어 경고를 끄고 다시 돌린다. (이 시도에서 UnicodeConverter, common, graphics, pdffile 등 여러 단계는 통과)

## 시도 5 (run 45026847930)
- 실패: `SheetData.cpp:2306: error: use of undeclared identifier 'DBL_MAX'` (DocxFormatLib). 10.0 소스가 float.h 를 직접 include 하지 않는데 gcc 에서는 다른 헤더를 통해 들어오고 emscripten(libc++)에서는 안 들어온다.
- 수정: embuild.sh 의 CFLAGS 에 `-include float.h` 를 넣어 모든 모듈에서 DBL_MAX 가 보이게 했다.

## 시도 6 (run 45027840522)
- DocxFormatLib 은 통과. 실패: `Common/Network` 에서 `localipc.cpp: fatal error: 'asio.hpp' file not found`. 10.0 에서 새로 생긴 local IPC 소스인데 asio 헤더가 필요하다.
- 수정: x2t 에서 안 쓰는 모듈이라 network.pro 의 LOCAL IPC 블록을 주석 처리했다.

## 시도 7 (run 45028654309)
- Network 통과. 실패: doctrenderer 단계 `drawingfile.h:42: fatal error: '../../PdfFile/PdfFile.h' file not found`. 10.0 의 drawingfile.h 가 PdfFile, XpsFile, DjVuFile, DocxRenderer, OFDFile 헤더를 include 한다.
- 수정: doctrenderer 단계에 그 모듈 디렉터리를 복사했다.

## 시도 8 (run 45030632230)
- 모든 라이브러리 단계(doctrenderer, OFDFile, StarMath 포함) 통과. 마지막 x2t 링크에서 실패: `wasm-ld: error: unknown argument: --exclude-libs`. 10.0 의 base.pri 가 app 링크에 `-Wl,--exclude-libs,ALL` 을 붙인다.
- 수정: base.pri 에서 `CONFIG += clang_no_exclude_libs` 로 그 옵션을 끈다. 이 시도는 약 40분 걸렸다(캐시 없이 전체 빌드).
