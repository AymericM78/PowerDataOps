# Command : `Add-XrmQueryLinkCondition` 

## Description

**Add filter to given link entity.** : Add new condition criteria to given link entity.

## Inputs

Name|Type|Position|Required|Default|Description
----|----|--------|--------|-------|-----------
Link|LinkEntity|1|true||LinkEntity where condition should be add..
Field|String|2|true||Column / attribute logical name to filter.
Condition|ConditionOperator|3|true||Condition operator to apply to column (ConditionOperator)
Values|Object[]|4|false||Value to apply in column filter (single object or array). Values are unwrapped from their PowerShell PSObject adapter. An empty array with In matches no row; an empty array with NotIn adds no condition.

## Outputs
Microsoft.Xrm.Sdk.Query.LinkEntity. The link, for pipeline chaining.

## Usage

```Powershell 
Add-XrmQueryLinkCondition [-Link] <LinkEntity> [-Field] <String> [-Condition] {Equal | NotEqual | GreaterThan | LessThan | GreaterEqual | LessEqual | Like | NotLike | In | NotIn | Between | NotBetween | Null | NotNull | Yesterday | Today | Tomorrow | Last7Days | Next7Days | LastWeek | ThisWeek | NextWeek | LastMonth | ThisMonth | NextMonth | On | OnOrBefore | OnOrAfter | LastYear | ThisYear | NextYear | LastXHours | NextXHours | LastXDays | NextXDays | LastXWeeks | NextXWeeks | LastXMonths | NextXMonths | LastXYears | NextXYears | EqualUserId | NotEqualUserId | EqualBusinessId | NotEqualBusinessId | ChildOf | Mask | NotMask | MasksSelect | Contains | DoesNotContain | EqualUserLanguage | NotOn | OlderThanXMonths | BeginsWith | DoesNotBeginWith | EndsWith | DoesNotEndWith | ThisFiscalYear | ThisFiscalPeriod | NextFiscalYear | NextFiscalPeriod | LastFiscalYear | LastFiscalPeriod | LastXFiscalYears | LastXFiscalPeriods | NextXFiscalYears | NextXFiscalPeriods | InFiscalYear | InFiscalPeriod | InFiscalPeriodAndYear | InOrBeforeFiscalPeriodAndYear | InOrAfterFiscalPeriodAndYear | EqualUserTeams | EqualUserOrUserTeams | Under | NotUnder | UnderOrEqual | Above | AboveOrEqual | EqualUserOrUserHierarchy | EqualUserOrUserHierarchyAndTeams | OlderThanXYears | OlderThanXWeeks | OlderThanXDays | OlderThanXHours | OlderThanXMinutes | ContainValues | DoesNotContainValues | EqualRoleBusinessId} [[-Values] <Object[]>] [<CommonParameters>]
``` 

## Examples

```Powershell 
$link = $query | Add-XrmQueryLink -ToEntityName "teammembership" -FromAttributeName "systemuserid" -ToAttributeName "systemuserid";
$link | Add-XrmQueryLinkCondition -Field "teamid" -Condition Equal -Values $teamId | Out-Null;
``` 


