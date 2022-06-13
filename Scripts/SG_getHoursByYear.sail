a!localVariables(
  local!dataSet: index(
    readexcelsheetpaging(
      excelDocument: ri!pricingDoc,
      sheetNumber: ri!sheetNumber,
      pagingInfo: a!pagingInfo(1, infinity())
    ),
    "data",
    {}
  ),
  local!totalDataRows: count(local!dataSet.values),
  local!totalYears: tointeger(
    remove(
      reject(fn!isnull, local!dataSet[4].values),
      count(
        reject(fn!isnull, local!dataSet[4].values)
      )
    )
  ),
  local!totalMonths: {
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  },
  local!flag: a!forEach(
    items: enumerate(local!totalDataRows),
    expression: if(
      fv!item > 5,
      local!dataSet[fv!item + 1].values,
      {}
    )
  ),
  local!findTotalYear: a!forEach(
    items: local!dataSet[5].values,
    expression: if(
      contains(
        a!forEach(
          items: local!totalYears,
          expression: "Total " & local!totalYears[fv!index]
        ),
        fv!item
      ),
      fv!index,
      {}
    )
  ),
  local!findTotalHour: a!forEach(
    items: local!dataSet[6].values,
    expression: if(fv!item = "Total Hours", fv!index, {})
  ),
  local!totalHourIndex: intersection(
    local!findTotalYear,
    local!findTotalHour
  ),
  local!test4: a!forEach(
    items: local!dataSet[4].values,
    expression: if(
      contains(local!totalYears, tointeger(fv!item)),
      fv!index,
      {}
    )
  ),
  {
    Users: a!forEach(
      items: local!flag,
      expression: if(
        fv!isLast,
        {},
        a!localVariables(
          local!check: fv!item,
          {
            PIN: tointeger(fv!item[2]),
            Name: fv!item[5],
            Hours: {
              Hours_Per_Year: createdictionary(
                local!totalYears,
                a!forEach(
                  items: local!totalHourIndex,
                  expression: local!check[fv!item]
                )
              ),
              Hours_Per_Month: createdictionary(
                local!totalMonths,
                a!forEach(
                  items: local!totalMonths,
                  expression: a!localVariables(
                    local!monthIndex: fv!index - 1,
                    createdictionary(
                      local!totalYears,
                      a!forEach(
                        items: local!test4,
                        expression: local!check[fv!item + (6 * local!monthIndex)]
                      )
                    )
                  )
                )
              )
            },
            Labor_Cost: {
              Labor_Cost_Per_Year: createdictionary(
                local!totalYears,
                a!forEach(
                  items: local!totalHourIndex,
                  expression: local!check[fv!item + 1]
                )
              ),
              Labor_Cost_Per_Month: createdictionary(
                local!totalMonths,
                a!forEach(
                  items: local!totalMonths,
                  expression: a!localVariables(
                    local!monthIndex: fv!index - 1,
                    createdictionary(
                      local!totalYears,
                      a!forEach(
                        items: local!test4,
                        expression: local!check[fv!item + (6 * local!monthIndex) + 1]
                      )
                    )
                  )
                )
              )
            },
            Overhead: {
              Overhead_Per_Year: createdictionary(
                local!totalYears,
                a!forEach(
                  items: local!totalHourIndex,
                  expression: local!check[fv!item + 2]
                )
              ),
              Overhead_Per_Month: createdictionary(
                local!totalMonths,
                a!forEach(
                  items: local!totalMonths,
                  expression: a!localVariables(
                    local!monthIndex: fv!index - 1,
                    createdictionary(
                      local!totalYears,
                      a!forEach(
                        items: local!test4,
                        expression: local!check[fv!item + (6 * local!monthIndex) + 2]
                      )
                    )
                  )
                )
              )
            },
            Mark_Up: {
              Mark_Up_Per_Year: createdictionary(
                local!totalYears,
                a!forEach(
                  items: local!totalHourIndex,
                  expression: local!check[fv!item + 3]
                )
              ),
              Mark_Up_Per_Month: createdictionary(
                local!totalMonths,
                a!forEach(
                  items: local!totalMonths,
                  expression: a!localVariables(
                    local!monthIndex: fv!index - 1,
                    createdictionary(
                      local!totalYears,
                      a!forEach(
                        items: local!test4,
                        expression: local!check[fv!item + (6 * local!monthIndex) + 3]
                      )
                    )
                  )
                )
              )
            },
            Additional_Cost: {
              Additional_Cost_Per_Year: createdictionary(
                local!totalYears,
                a!forEach(
                  items: local!totalHourIndex,
                  expression: local!check[fv!item + 4]
                )
              ),
              Additional_Cost_Per_Month: createdictionary(
                local!totalMonths,
                a!forEach(
                  items: local!totalMonths,
                  expression: a!localVariables(
                    local!monthIndex: fv!index - 1,
                    createdictionary(
                      local!totalYears,
                      a!forEach(
                        items: local!test4,
                        expression: local!check[fv!item + (6 * local!monthIndex) + 4]
                      )
                    )
                  )
                )
              )
            },
            Total_Cost: {
              Total_Cost_Per_Year: createdictionary(
                local!totalYears,
                a!forEach(
                  items: local!totalHourIndex,
                  expression: local!check[fv!item + 5]
                )
              ),
              Total_Cost_Per_Month: createdictionary(
                local!totalMonths,
                a!forEach(
                  items: local!totalMonths,
                  expression: a!localVariables(
                    local!monthIndex: fv!index - 1,
                    createdictionary(
                      local!totalYears,
                      a!forEach(
                        items: local!test4,
                        expression: local!check[fv!item + (6 * local!monthIndex) + 5]
                      )
                    )
                  )
                )
              )
            }
          }
        )
      )
    ),
    Grand_Total: a!localVariables(
      local!totalValue: a!forEach(
        items: local!dataSet.values,
        expression: if(fv!isLast, fv!item, {})
      ),
      a!forEach(
        items: local!flag,
        expression: if(
          fv!isLast,
          a!localVariables(
            local!check: fv!item,
            {
              Total_Hours: {
                Yearly: createdictionary(
                  local!totalYears,
                  a!forEach(
                    items: local!totalHourIndex,
                    expression: local!totalValue[fv!item]
                  )
                ),
                Monthly: createdictionary(
                  local!totalMonths,
                  a!forEach(
                    items: local!totalMonths,
                    expression: a!localVariables(
                      local!monthIndex: fv!index - 1,
                      createdictionary(
                        local!totalYears,
                        a!forEach(
                          items: local!test4,
                          expression: local!check[fv!item + (6 * local!monthIndex)]
                        )
                      )
                    )
                  )
                )
              },
              Total_Labor_Cost: {
                Yearly: createdictionary(
                  local!totalYears,
                  a!forEach(
                    items: local!totalHourIndex,
                    expression: local!totalValue[fv!item + 1]
                  )
                ),
                Monthly: createdictionary(
                  local!totalMonths,
                  a!forEach(
                    items: local!totalMonths,
                    expression: a!localVariables(
                      local!monthIndex: fv!index - 1,
                      createdictionary(
                        local!totalYears,
                        a!forEach(
                          items: local!test4,
                          expression: local!check[fv!item + (6 * local!monthIndex) + 1]
                        )
                      )
                    )
                  )
                )
              },
              Total_Overhead: {
                Yearly: createdictionary(
                  local!totalYears,
                  a!forEach(
                    items: local!totalHourIndex,
                    expression: local!totalValue[fv!item + 2]
                  )
                ),
                Monthly: createdictionary(
                  local!totalMonths,
                  a!forEach(
                    items: local!totalMonths,
                    expression: a!localVariables(
                      local!monthIndex: fv!index - 1,
                      createdictionary(
                        local!totalYears,
                        a!forEach(
                          items: local!test4,
                          expression: local!check[fv!item + (6 * local!monthIndex) + 2]
                        )
                      )
                    )
                  )
                )
              },
              Total_Mark_Up: {
                Yearly: createdictionary(
                  local!totalYears,
                  a!forEach(
                    items: local!totalHourIndex,
                    expression: local!totalValue[fv!item + 3]
                  )
                ),
                Monthly: createdictionary(
                  local!totalMonths,
                  a!forEach(
                    items: local!totalMonths,
                    expression: a!localVariables(
                      local!monthIndex: fv!index - 1,
                      createdictionary(
                        local!totalYears,
                        a!forEach(
                          items: local!test4,
                          expression: local!check[fv!item + (6 * local!monthIndex) + 3]
                        )
                      )
                    )
                  )
                )
              },
              Total_Additional_Cost: {
                Yearly: createdictionary(
                  local!totalYears,
                  a!forEach(
                    items: local!totalHourIndex,
                    expression: local!totalValue[fv!item + 4]
                  )
                ),
                Monthly: createdictionary(
                  local!totalMonths,
                  a!forEach(
                    items: local!totalMonths,
                    expression: a!localVariables(
                      local!monthIndex: fv!index - 1,
                      createdictionary(
                        local!totalYears,
                        a!forEach(
                          items: local!test4,
                          expression: local!check[fv!item + (6 * local!monthIndex) + 4]
                        )
                      )
                    )
                  )
                )
              },
              Final_Cost: {
                Yearly: createdictionary(
                  local!totalYears,
                  a!forEach(
                    items: local!totalHourIndex,
                    expression: local!totalValue[fv!item + 5]
                  )
                ),
                Monthly: createdictionary(
                  local!totalMonths,
                  a!forEach(
                    items: local!totalMonths,
                    expression: a!localVariables(
                      local!monthIndex: fv!index - 1,
                      createdictionary(
                        local!totalYears,
                        a!forEach(
                          items: local!test4,
                          expression: local!check[fv!item + (6 * local!monthIndex) + 5]
                        )
                      )
                    )
                  )
                )
              }
            }
          ),
          {}
        )
      )[1]
    )
  }
)