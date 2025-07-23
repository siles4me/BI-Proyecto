let
    Origen = Table.NestedJoin(Sales, {"Store_Code"}, Stores, {"Store_Code"}, "Stores", JoinKind.Inner),
    ExpandirStores = Table.ExpandTableColumn(Origen, "Stores", {"Store_Name", "Country_Format"}, {"Store_Name", "Country_Format"}),

    MergeCountry = Table.NestedJoin(ExpandirStores, {"Country_Format"}, Country_Format, {"Country_Format"}, "Country_Format.1", JoinKind.Inner),
    ExpandirCountry = Table.ExpandTableColumn(MergeCountry, "Country_Format.1", {"Country_Code", "Country_Name", "Format_Code", "Format_Name"}, {"Country_Code", "Country_Name", "Format_Code", "Format_Name"}),

    AgruparVentas = Table.Group(
        ExpandirCountry,
        {"Date", "Country_Format", "Country_Name", "Format_Name"},
        {{"Sales", each List.Sum([Sales]), type nullable number}}
    ),

    CambiarTipoSales = Table.TransformColumnTypes(AgruparVentas, {{"Sales", type number}}),

    MergePlan = Table.NestedJoin(CambiarTipoSales, {"Date", "Country_Format"}, Sales_Plan, {"Date", "Country_Format"}, "Sales_Plan", JoinKind.Inner),
    ExpandirPlan = Table.ExpandTableColumn(MergePlan, "Sales_Plan", {"Sales_Plan"}, {"Sales_Plan"}),

    AgregarAlcance = Table.AddColumn(ExpandirPlan, "Alcance_Plan", each 
        if [Sales] = 0 then null else 1 - (([Sales_Plan] - [Sales]) / [Sales])
    ),

    CambiarTipoAlcance = Table.TransformColumnTypes(AgregarAlcance, {{"Alcance_Plan", Percentage.Type}})
in
    CambiarTipoAlcance
