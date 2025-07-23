let
    Origen = Table.NestedJoin(Sales, {"Store_Code"}, Stores, {"Store_Code"}, "Stores", JoinKind.Inner),
    ExpandirStores = Table.ExpandTableColumn(Origen, "Stores", {"Store_Name", "Country_Format"}, {"Store_Name", "Country_Format"}),

    MergeCountry = Table.NestedJoin(ExpandirStores, {"Country_Format"}, Country_Format, {"Country_Format"}, "Country_Format.1", JoinKind.Inner),
    ExpandirCountry = Table.ExpandTableColumn(MergeCountry, "Country_Format.1", {"Country_Code", "Country_Name", "Format_Code", "Format_Name"}, {"Country_Code", "Country_Name", "Format_Code", "Format_Name"}),

    AgregarMes = Table.AddColumn(ExpandirCountry, "Mes", each Date.Month([Date])),

    FiltrarCondiciones = Table.SelectRows(
        AgregarMes,
        each ([Mes] = 4) and ([Country_Name] = "Costa Rica") and ([Format_Name] = "Bodegas")
    ),

    AgruparPorTienda = Table.Group(FiltrarCondiciones, {"Store_Name"}, {
        {"Sales", each List.Sum([Sales]), type nullable number}
    }),

    OrdenarPorVentas = Table.Sort(AgruparPorTienda, {{"Sales", Order.Descending}}),

    Top10 = Table.FirstN(OrdenarPorVentas, 10)
in
    Top10
