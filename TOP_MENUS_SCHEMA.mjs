import {prefix} from "./Settings.mjs";

export const TOP_MENUS_SCHEMA = [
    {
        "icon": "",
        "title": "和利时DCS",
        "children": [
            {
                "icon": "",
                "title": "主控制器",
                "src1": `${prefix}/drawio/和利时_主控制器单元1.drawio.html`
            }
        ]
    }, {
        "icon": "",
        "title": "MES相关",
        "children": [
            {
                "icon": "",
                "title": "MES上下游",
                "src1": `${prefix}/drawio/MES上下游1.drawio.html`
            },
            {
                "icon": "",
                "title": "SQL相关",
                "src1": `${prefix}/drawio/SQL相关.drawio.html`
            }
        ]
    }, {
        "icon": "",
        "title": "中控DCS",
        "children": [
            {
                "icon": "",
                "title": "基本",
                "src1": `${prefix}/drawio/中控/组态软件基本.drawio.html`
            }, {
                "icon": "",
                "title": "主控制器",
                "src1": `${prefix}/drawio/中控/控制器单元.drawio.html`
            }, {
                "icon": "",
                "title": "PID功能块的对比",
                "src1": `${prefix}/drawio/中控/PID功能块的对比.drawio.html`
            }
        ]
    }
]
