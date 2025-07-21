# Command : `Trace-XrmFunction` 

## Description

**Output verbose information about function call.** : Core module method to trace information and measure calls performance.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Name|String|1|true||Called function name.
Stage|String|2|true||Indicate when tracung is called from function : Start or Stop.
Parameters|Object[]|3|false||List of arguments provided to function.
StopWatch|Stopwatch|4|false||StopWath object initialized during first function call in order to measure overall duration.


## Usage

```Powershell 
Trace-XrmFunction [-Name] <String> [-Stage] <String> [[-Parameters] <Object[]>] [[-StopWatch] <Stopwatch>] 
[<CommonParameters>]
``` 


