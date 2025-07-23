let
    Origen = Table.NestedJoin(Sales, {"Store_Code"}, Stores, {"Store_Code"}, "Stores", JoinKind.Inner),
    ExpandirStores = Table.ExpandTableColumn(Origen, "Stores", {"Store_Name", "Country_Format"}, {"Store_Name", "Country_Format"}),

    MergeCountry = Table.NestedJoin(ExpandirStores, {"Country_Format"}, Country_Format, {"Country_Format"}, "Country_Format.1", JoinKind.Inner),
    ExpandirCountry = Table.ExpandTableColumn(MergeCountry, "Country_Format.1", {"Country_Code", "Country_Name", "Format_Code", "Format_Name"}, {"Country_Code", "Country_Name", "Format_Code", "Format_Name"}),

    AgregarUnidadesPromedio = Table.AddColumn(ExpandirCountry, "Unidades_Promedio", each [Quantity] / [Transactions]),
    CambiarTipoUnidades = Table.TransformColumnTypes(AgregarUnidadesPromedio, {{"Unidades_Promedio", type number}}),

    AgregarTransaccionPromedio = Table.AddColumn(CambiarTipoUnidades, "Transaccion_Promedio", each [Sales] / [Transactions]),
    CambiarTipoTransaccion = Table.TransformColumnTypes(AgregarTransaccionPromedio, {{"Transaccion_Promedio", type number}}),

    AgregarPrecioPromedio = Table.AddColumn(CambiarTipoTransaccion, "Precio_Promedio", each [Sales] / [Quantity]),
    CambiarTipoPrecio = Table.TransformColumnTypes(AgregarPrecioPromedio, {{"Precio_Promedio", type number}}),

    AgruparPorNivel = Table.Group(
        CambiarTipoPrecio,
        {"Country_Name", "Format_Name", "Store_Name", "Date"},
        {
            {"Sales", each List.Sum([Sales]), type nullable number},
            {"Quantity", each List.Sum([Quantity]), type nullable number},
            {"Transactions", each List.Sum([Transactions]), type nullable number}
        }
    ),

    AgregarKPIUnidades = Table.AddColumn(AgruparPorNivel, "Unidades_Promedio", each [Quantity] / [Transactions]),
    AgregarKPITransaccion = Table.AddColumn(AgregarKPIUnidades, "Transaccion_Promedio", each [Sales] / [Transactions]),
    AgregarKPIPrecio = Table.AddColumn(AgregarKPITransaccion, "Precio_Promedio", each [Sales] / [Quantity]),

    CambiarTiposFinal = Table.TransformColumnTypes(
        AgregarKPIPrecio,
        {
            {"Unidades_Promedio", type number},
            {"Transaccion_Promedio", type number},
            {"Precio_Promedio", type number}
        }
    )
in
    CambiarTiposFinal
