Lab 5.2
---

In this lab, we'll be profiling a special version of Smarticle to see if we can't find some bottlenecks or places that we can optimize.

Suggested Resources
---
- [Performance Tuning Guide](https://developer.apple.com/library/ios/documentation/iphone/conceptual/iphoneosprogrammingguide/PerformanceTuning/PerformanceTuning.html)
- [Instruments User Guide](https://developer.apple.com/library/ios/documentation/developertools/conceptual/instrumentsuserguide/InstrumentsQuickStart/InstrumentsQuickStart.html)

Profiling with Instruments
---
1. Start with a special version of Smarticle in the repo under week 5, called SmarticlePerformance.
2. Make sure you have the simulator selected.
3. Run the project in Profile mode either by long-clicking the normal Play button and choosing Profile, or through the menu (Product > Profile).
4. After building, this will automatically launch Instruments.  Sometimes, it will ask you to type in your password.
5. On the left hand panel of the modal that appears.  Select the CPU category under iOS Simulator.
6. Select the *Time Profiler* trace template and hit **Profile**.

Time Profiling
---
1. Back in the Simulator, tap one of the main article categories other than favorites.
2. Scroll up and down for a few seconds until you have a decent amount of data.
3. Use the Inspection Range filter to zero in on the section of the graph where the most activity is happening.  Be sure to filter out the initial start up spike for now, as it may skew the results.
4. Switch to the call tree view by using the dropdown at the bottom of the graph view.
5. On the left hand panel, tick the checkbox for *Hide System Libraries*.  Notice how t
6. Drill down by opening the disclosure triangles on each level of the call stack until you hit the bottom.  You can also expand an entire hierarchy by Comman+clicking.
7. When you get towards the bottom, double click the topmost call below main to see the hottest call subpaths.
8. What is the greatest bottleneck to main thread performance?  Are there any ways we can further optimize this?


Memory Profiling
---
1. Close Instruments (if you don't it will automatically start tracing with Time Profiler again).
2. Repeat the steps from the first section, but this time choose the *Leaks* template from the Memory section when the Instrements modal appears.
3. Back in the Simulator, click one of the article categories and wait for it to load, then click back to go back to the home screen.  Do this several times and pay attention to the graph.  You should notice a disturbing trend.  There's definitely a memory leak.
4. Select the Leaks graph by clicking its row, and you will see ***nothing***!  Thanks Apple.
5. Instead, we're going to use Generation Analysis to find this leak.  Select the Allocations instrument.
6. Back in the Simulator, navigate back to the main view if you aren't already there.  In Instruments, click the button on the left hand panel that says "Mark Generation".
7. A little flag on the graph will appear.  This will save a snaphot of objects in memory at that point in time and represents our baseline.
8. Now, navigate forward to a list of articles and then navigate back to the main page.
9. Take another snapshot by hitting "Mark Generation".
10. Repeat steps 8 and 9 a few times.
11. You should now see a number of generations listed in the lower half of the Instruments window.  Each one represents all the objects that were allocated during that generation, but never deallocated.  We are leaking almost 2 MB each time.  Let's try to figure out the culprit.
12. Choose one of the generations to analyze by clicking the little rightward facing arrow to the right of its name.
13. Now you should see all these objects broken down by the call tree.  Tick that little checkbox again on the left *Hide System Libraries* so that you can see only the classes we're responsible for.
14. Double-click the topmost call below main.  What seems to be causing this problem?