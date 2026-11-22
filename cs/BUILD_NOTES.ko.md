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
