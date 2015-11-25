<?php
/**
 * Verone CRM | http://www.veronecrm.com
 *
 * @copyright  Copyright (C) 2015 Adam Banaszkiewicz
 * @license    GNU General Public License version 3; see license.txt
 */

return [
    [
        'name' => 'settingsGlobal',
        'id' => 'mod.Invoice.Invoice',
        'access' => [
            [
                'id' => 'core.module',
                'name' => 'auth.core.module'
            ],
            [
                'id' => 'core.read',
                'name' => 'auth.core.read'
            ],
            [
                'id' => 'core.write',
                'name' => 'auth.core.write'
            ],
            [
                'id' => 'core.delete',
                'name' => 'auth.core.delete'
            ]
        ]
    ],
    [
        'name' => 'invoiceTilesPermissions',
        'id' => 'mod.Invoice.Tile',
        'access' => [
            [
                'id' => 'mod.invoice.tile.cashflow',
                'name' => 'invoiceTileCashFlowe'
            ]
        ]
    ]
];
