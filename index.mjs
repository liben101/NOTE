import {prefix} from "./Settings.mjs";
import {TOP_MENUS_SCHEMA} from "./TOP_MENUS_SCHEMA.mjs";

$(document).ready(async function() {

    let MENUS_1 = TOP_MENUS_SCHEMA

    var ACTIVE_TOP_HEADER = null


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

            var menu_1_item = $('<div>', {
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
                    let menu_2_item = document.createElement('div')
                    menu_2_item.className = 'children-header-item1'
                    menu_2_item.innerHTML = `${_index + 1}. ${_value.title}`

                    menu_2_item.addEventListener('click', (ee) => {
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


