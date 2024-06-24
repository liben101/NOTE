
let MENUS_1 = await fetch("./json/TOP_MENUS_SCHEMA.json").then(res => {
    return res.json()
})


var ACTIVE_TOP_HEADER = null

var iframe1 = document.getElementById('iframe1')

function initMenu1() {
    /**
     * 
     * 初始化第一层menu
     * 
     **/

    let topheader1 = document.getElementById('top-header-1')

    // 遍历主菜单
    MENUS_1.forEach(item => {

        let menu_1_item = document.createElement('div')
        menu_1_item.className = 'top-header-item'
        menu_1_item.innerHTML = `${item.title} 🔽`


        // ------------------------------------------------

        let menu_1 = document.getElementById('children-header-1')

        // _chil是顶部子菜单列表
        let _chil = item.children

        menu_1_item.addEventListener('click', (_e) => {

            if (ACTIVE_TOP_HEADER) {
                ACTIVE_TOP_HEADER.classList.remove('active')
            }

            ACTIVE_TOP_HEADER = menu_1_item
            menu_1_item.classList.add('active')


            menu_1.innerHTML = ''
            _chil.forEach((_value, _index) => {
                let menu_2_item = document.createElement('div')
                menu_2_item.className = 'children-header-item1'
                menu_2_item.innerHTML = `${_index + 1}. ${_value.title}`

                menu_2_item.addEventListener('click', (ee) => {
                    iframe1.src = _value.src1
                })
                menu_1.appendChild(menu_2_item)
            })
        })

        topheader1.appendChild(menu_1_item)

    })

}

initMenu1()

