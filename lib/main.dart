import 'package:flutter/material.dart';
import 'package:oscilloscope/oscilloscope.dart';
import 'package:sensors/sensors.dart';
import 'dart:math';
import 'dart:async';
import 'fetch-json.dart';
import 'chart-demo.dart';
import 'chart-demo2.dart';

/*
googlechart JS 라이브러리를 쓰기 위해서는
 <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
 이런식으로 loader.js 를 입력한 후 web 에서 사용할 수 있음.
그래서 flutter 에서 googld chart API 를 쓰기 힘든데, 만약 JS 라이브러리를 flutter 에
포팅해줄 수 있는 flutter 플러그인이 있다면?
검색해봤는데 쉽지는 않은 것 같음

==> 그냥 JSON 가져와서 파싱한 후 osilloscope 나 time-serise chart 에 랜더링해주는 게 최선인듯


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
// void main() => runApp(new SimpleTimeSeriesChart());
// void main() => runApp(new ItemDetailsPage());
// void main() => runApp(MyApp());
void main() => runApp(FetchJsonTest(post: fetchPost()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Oscilloscope Display Example",
      home: Shell(),
    );
  }
}

class Shell extends StatefulWidget {
  @override
//  _ShellState createState() => _ShellState();
  _ShellState2 createState() => _ShellState2();
}

class _ShellState extends State<Shell> {
  List<double> traceX = List();

  @override
  initState() {
    super.initState();
    accelerometerEvents.listen((AccelerometerEvent event) {
      setState(() {
        traceX.add(event.x);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Create A Scope Display
    Oscilloscope scopeOne = Oscilloscope(
      padding: 20.0,
      backgroundColor: Colors.black,
      traceColor: Colors.green,
      yAxisMax: 10.0,
      yAxisMin: -10.0,
      dataSet: traceX,
    );

    // Generate the Scaffold
    return Scaffold(
      appBar: AppBar(
        title: Text("OscilloScope Demo"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 1, child: scopeOne),
        ],
      ),
    );
  }
}

class _ShellState2 extends State<Shell> {
  List<double> traceSine = List();
  List<double> traceCosine = List();
  double radians = 0.0;
  Timer _timer;

  /// method to generate a Test  Wave Pattern Sets
  /// this gives us a value between +1  & -1 for sine & cosine
  _generateTrace(Timer t) {
    // generate our  values
    var sv = sin((radians * pi));
    var cv = cos((radians * pi));

    // Add to the growing dataset
    setState(() {
      traceSine.add(sv);
      traceCosine.add(cv);
    });

    // adjust to recyle the radian value ( as 0 = 2Pi RADS)
    radians += 0.05;
    if (radians >= 2.0) {
      radians = 0.0;
    }
  }

  @override
  initState() {
    super.initState();
    // create our timer to generate test values
    _timer = Timer.periodic(Duration(milliseconds: 60), _generateTrace);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Create A Scope Display for Sine
    Oscilloscope scopeOne = Oscilloscope(
      showYAxis: true,
      yAxisColor: Colors.orange,
      padding: 20.0,
      backgroundColor: Colors.black,
      traceColor: Colors.green,
      yAxisMax: 1.0,
      yAxisMin: -1.0,
      dataSet: traceSine,
    );

    // Create A Scope Display for Cosine
    Oscilloscope scopeTwo = Oscilloscope(
      showYAxis: true,
      padding: 20.0,
      backgroundColor: Colors.black,
      traceColor: Colors.yellow,
      yAxisMax: 1.0,
      yAxisMin: -1.0,
      dataSet: traceCosine,
    );

    // Generate the Scaffold
    return Scaffold(
      appBar: AppBar(
        title: Text("OscilloScope Demo"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(flex: 1, child: scopeOne),
          Expanded(
            flex: 1,
            child: scopeTwo,
          ),
        ],
      ),
    );
  }
}
