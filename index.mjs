import {prefix} from "./Settings.mjs";
import {TOP_MENUS_SCHEMA} from "./TOP_MENUS_SCHEMA.mjs";

$(document).ready(async function() {

    let MENUS_1 = TOP_MENUS_SCHEMA

    let ACTIVE_TOP_HEADER = null;


    const iframe1 = $('#iframe1')

    function initMenu1() {
        /**
         *
         * 初始化第一层menu
         *
         **/

        const topheader1 = $('#top-header-1')

        // 遍历主菜单
        MENUS_1.forEach(item => {

            const menu_1_item = $('<div>', {
                class: 'top-header-item',
                text: item.title
            });

            // ------------------------------------------------

            let menu_1 = $('#children-header-1')

            // _chil是顶部子菜单列表
            let _chil = item.children

            menu_1_item.click((_e) => {

                if (ACTIVE_TOP_HEADER) {
                    ACTIVE_TOP_HEADER.removeClass('active')
                }

                ACTIVE_TOP_HEADER = menu_1_item
                menu_1_item.addClass('active')


                menu_1.html('')
                _chil.forEach((_value, _index) => {


                    const menu_2_item = $('<div>', {
                        class: 'children-header-item1',
                        text: `${_index + 1}. ${_value.title}`
                    });

                    menu_2_item.click((ee) => {
                        iframe1.attr('src',_value.src1)
                    })
                    menu_1.append(menu_2_item)
                })
            })

            topheader1.append(menu_1_item)

        })

    }

    initMenu1()


})


