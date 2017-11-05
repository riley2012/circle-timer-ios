# circle-timer-ios
A progress circle view that animates over time, starting out as a full circle and erasing itself to reveal the view behind the circle

<p align="center">
  <img src="https://github.com/riley2012/circle-timer-ios/blob/master/CircleTimer/Timer.gif" width="350"/>
</p>

The view animates a CAShapeLayer. It draws a circular path whose radius is half of the circle. 

Theh path is drawn with a line width that is as wide as the radius of the circle. 
It animates to the stroke end.
