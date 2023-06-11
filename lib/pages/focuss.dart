import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/colors.dart';

class PomodoroTimerPage extends StatefulWidget {
  @override
  _PomodoroTimerPageState createState() => _PomodoroTimerPageState();
}

class _PomodoroTimerPageState extends State<PomodoroTimerPage> {
  int _workDuration = 25;
  int _breakDuration = 5;
  int _currentDuration = 25 * 60;
  late Timer _timer;
  bool _isWorking = true;
  bool _isPaused = false;

  void _startTimer() {
    setState(() {
      _isPaused = false;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          if (_currentDuration > 0) {
            _currentDuration--;
          } else {
            if (_isWorking) {
              _currentDuration = _breakDuration * 60;
              _isWorking = false;
            } else {
              _currentDuration = _workDuration * 60;
              _isWorking = true;
            }
          }
        });
      });
    });
  }

  void _stopTimer() {
    setState(() {
      _isPaused = true;
      _timer.cancel();
    });
  }

  void _resetTimer() {
    setState(() {
      _currentDuration = _workDuration * 60;
      _isWorking = true;
      _isPaused = false;
      _timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    String minutes = (_currentDuration ~/ 60).toString().padLeft(1, '0');
    String seconds = (_currentDuration % 60).toString().padLeft(1, '0');

    return Scaffold(
      backgroundColor: tdBGColor,
      body: Center(
        child:  
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: 
          [ Container(width: 250, height: 250, child: Image(
              image: AssetImage('assets/images/semangka fokus.gif'), fit: BoxFit.cover,),),
            // ClipOval(child: Image(
            //   image: AssetImage('assets/images/semangka fokus.gif'),
            //   fit: BoxFit.cover),),
            Text(
              _isWorking ? 'Work' : 'Break',
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              '$minutes:$seconds',
              style: TextStyle(
                fontSize: 80.0,
              ),
            ),
            SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: _isPaused ? null : _startTimer,
                  child: Icon(Icons.play_arrow),
                ),
                // pause button, sekali nge-pause harus resume
                SizedBox(width: 20.0),
                FloatingActionButton(
                  onPressed: _stopTimer,
                  child: Icon(Icons.stop),
                ),
                SizedBox(width: 20.0),
                FloatingActionButton(
                  onPressed: _resetTimer,
                  child: Icon(Icons.refresh),
                ),
              ],
            ),
          ],
        ), 
      ),
    );
  }
}
