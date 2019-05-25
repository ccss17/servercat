import 'package:flutter/material.dart';
import 'app.dart';
import 'home.dart';
import 'fetch-cpu.dart';

void main() => runApp(FlutterNetdata());
// void main() => runApp(FetchProcesses(post: fetchPost('system.processes')));
// void main() => runApp(FetchCpu(post: fetchPost('system.cpu')));

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