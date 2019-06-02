import 'package:flutter/material.dart';
import 'app.dart';
import 'home.dart';
import 'package:flutter_netdata/netdata-charts/fetch-ram.dart';
// 배찌 메인 아이콘 몇 개정 도 활용... 
//  다음 주 월요일에는 로그랑 히스토리 기능 + 디렉토리 살짝 보여줄 수 있는 정도로만 하고
// 월요일에는 다 프로젝트를 끝낸ㄴ다는 느낌으로 가자
// 그리고 또 다른 디테일은 1.5 2.0 버전에 넣겠다 라는 로드맵을 짜버려 그냥! 

// 디렉토리 나열 그래서 만약 /var/log/nginx 를 버튼 클릭한다면, 그 파일의 컨텐츠를 볼 수 있는 거지 
// 차트는 디폴트로 CPU, 프로세스, 디스크 IO 보여줘바바 버전 1.0 에서는 차트를  다이나믹하게 추가해준느 건 나중에 해도 되!
// 자주 사용하는 커맨드 버튼을 Listview 로 위로 올리기. - 그리고 그 버튼 바에 커맨드 재실행, 


void main() => runApp(FlutterNetdata());
// void main() => runApp(FetchProcesses(post: fetchPost('system.processes')));
// void main() => runApp(FetchCpu(post: fetchPost('system.cpu')));
/*https://github.com/netdata/netdata/issues/2031
넷데이터 어플을 깔쌈하게 만들어주면 0.99 달러 혹은 1.99 달러라도 지불할 용의가 있다는 것
즉 서버 모니터링에 대한 수요가 분명히 있고, 그 모니터링에 대한 접근성을 쉽게 하기 위하여
서버 모니터링 "어플" 에 대한 수요가 있다는 것. 

기존의 넷데이터 어플이 차트를 완벽하게 구현하고 있긴 하지만
SSH 나 일정 수준 올라가면 알람을 울리게 해주는 기능이나
팀원들과 서버 모니터링을 편하게 공유할 수 있게 해주는 기능에 대한 수요도 있음.
그래서 이런 기능들도 깔끔하게 구현한다면 시장 경쟁력이 생김.
또 기존의 넷데이터 어플은 디자인이 마음에 들지 않음. 
블랙 테마로 SF 느낌 나도록 하지만 지저분하지 않고 깔끔한 디자인으로.. 
 * */

/*
netdata API
https://registry.my-netdata.io/swagger/#/

차트 플러그인
https://pub.dev/packages/flutter_charts
https://pub.dev/packages/charts_flutter
https://pub.flutter-io.cn/packages/chartjs#-readme-tab-

내가 정확하게 원하는 질문:
https://stackoverflow.com/questions/51739064/flutter-json-and-time-series-charts

https://itsallwidgets.com/ 여기 개쩐당
https://www.figmaresources.com/resources/aQq5ajk43Xht97RRm

lnav 로그 - tcpdump 메시지도 가능하고 - iftop 상태 메시지 - gotop 서버 로드율 - bmon 서버 대역폭 상태
iftop - 연결이 성립된 TCP 연결들 - IP - 소모하는 대역폭 - 전체적인 트래픽 - TX - RX - TOTAL - peak - rates
lnav - HTTP 메소드 - GET, IP, 경로 - POST, IP, 경로
bmon - RX - TX - RX, TX 들의 그래프
gotop - CPU Usage - Disk Usaeg -Memory Usage - Temperature - Network Useag (RX, TX) - Process
중요한 것 - w (누가 접속해있는지)

이거 코드 엄청 간단해서 oscilloscope 에서 선 하나 더 그리게 하는 거
그냥 내가 커스터마이징 할 수 있을 거 같은데??

flutter 제이슨
https://flutter.dev/docs/development/data-and-backend/json

flutter 차트
https://google.github.io/charts/flutter/gallery.html
https://flutterawesome.com/tag/chart/
* */