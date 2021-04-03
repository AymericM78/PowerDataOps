# Command : `Add-XrmQueryCondition` 

## Description

**Add filter to given query expression.** : Add new condition criteria to given query expression.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Query|QueryExpression|1|true||QueryExpression where condition should be add.
Field|String|2|true||Column / attribute logical name to filter.
Condition|ConditionOperator|3|true||Condition operator to apply to column (ConditionOperator)
CompareFieldValue|SwitchParameter|named|false|False|Specify if column filter should be evaluated according to another column.
Values|Object[]|4|false||Value to apply in column filter (single object or array)

## Outputs
Microsoft.Xrm.Sdk.Query.QueryExpression

## Usage

```Powershell 
Add-XrmQueryCondition [-Query] <QueryExpression> [-Field] <String> [-Condition] {Equal | NotEqual | GreaterThan | LessThan | GreaterEqual | LessEqual | Like | NotLike 
| In | NotIn | Between | NotBetween | Null | NotNull | Yesterday | Today | Tomorrow | Last7Days | Next7Days | LastWeek | ThisWeek | NextWeek | LastMonth | ThisMonth | 
NextMonth | On | OnOrBefore | OnOrAfter | LastYear | ThisYear | NextYear | LastXHours | NextXHours | LastXDays | NextXDays | LastXWeeks | NextXWeeks | LastXMonths | 
NextXMonths | LastXYears | NextXYears | EqualUserId | NotEqualUserId | EqualBusinessId | NotEqualBusinessId | ChildOf | Mask | NotMask | MasksSelect | Contains | 
DoesNotContain | EqualUserLanguage | NotOn | OlderThanXMonths | BeginsWith | DoesNotBeginWith | EndsWith | DoesNotEndWith | ThisFiscalYear | ThisFiscalPeriod | 
NextFiscalYear | NextFiscalPeriod | LastFiscalYear | LastFiscalPeriod | LastXFiscalYears | LastXFiscalPeriods | NextXFiscalYears | NextXFiscalPeriods | InFiscalYear | 
InFiscalPeriod | InFiscalPeriodAndYear | InOrBeforeFiscalPeriodAndYear | InOrAfterFiscalPeriodAndYear | EqualUserTeams | EqualUserOrUserTeams | Under | NotUnder | 
UnderOrEqual | Above | AboveOrEqual | EqualUserOrUserHierarchy | EqualUserOrUserHierarchyAndTeams | OlderThanXYears | OlderThanXWeeks | OlderThanXDays | 
OlderThanXHours | OlderThanXMinutes | ContainValues | DoesNotContainValues} [-CompareFieldValue] [[-Values] <Object[]>] [<CommonParameters>]
``` 


