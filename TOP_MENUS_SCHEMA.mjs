import {prefix} from "./Settings.mjs";

export const TOP_MENUS_SCHEMA = [
    {
        "icon": "",
        "title": "Java核心技术·卷 I（第11版）",
        "children": [
            {
                "icon": "",
                "title": "第7章 异常、断言和日志.pdf",
                "src1": `${prefix}/pdf/第7章 异常、断言和日志.pdf`
            },
            {
                "icon": "",
                "title": "第10章 图形用户界面程序设计.pdf",
                "src1": `${prefix}/pdf/第10章 图形用户界面程序设计.pdf`
            },
            {
                "icon": "",
                "title": "第11章 Swing用户界面组件.pdf",
                "src1": `${prefix}/pdf/第11章 Swing用户界面组件.pdf`
            }
        ]
    },
    // {
    //     "icon": "",
    //     "title": "JAVA",
    //     "children": [
    //         {
    //             "icon": "",
    //             "title": "Java核心技术·卷 II（原书第11版）：高级特性.pdf",
    //             "src1": `${prefix}/pdf/Java核心技术·卷 II（原书第11版）：高级特性.pdf`
    //         }
    //     ]
    // },
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
    },
    {
        "icon": "",
        "title": "SQL Server",
        "children": [{
            "icon": "",
            "title": "事务概念",
            "src1": `${prefix}/drawio/SQL/SQL Server/事务概念.drawio.html`
        },
            {
                "icon": "",
                "title": "使用事务",
                "src1": `${prefix}/drawio/SQL/SQL Server/使用事务.drawio.html`
            },  
            {
                "icon": "",
                "title": "事务的并发与隔离级别",
                "src1": `${prefix}/drawio/SQL/SQL Server/事务的并发与隔离级别.drawio.html`
            },  
        ]
    }
]
