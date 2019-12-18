#!/usr/bin/python

from lcd import lcddriver
import time

lcd = lcddriver.lcd()

lcd.lcd_display_string("HI THERE", 1)

time.sleep(5)  # sleep 5 seconds

lcd.lcd_clear()

lcd = None


