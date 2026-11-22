# 빌드 기록 (10.0)

- 시작: cs/main 에서 cs/x2t-10.0 브랜치를 만들고 core/ 를 ONLYOFFICE core ed63e94 로 교체했다.
- 현재 core/ 는 Euro-Office 9.3.2 기반이라서 ONLYOFFICE 원본과 줄 단위로 다르다. 그래서 subtree pull 대신 원본 트리를 통째로 넣고, CryptPad 표시("CryptPad:") 가 붙은 수정만 다시 적용했다.

## 시도 1 (run 45023514222)
- 실패: `unknown flag: --jobs`. 러너에 podman 이 같이 깔려 있어서 build.sh 가 podman 용 옵션을 docker 에도 넘겼다.
- 수정: docker 가 있으면 PARAMS 를 비우도록 build.sh 를 고쳤다.
