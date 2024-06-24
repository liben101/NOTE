
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

        let div1 = document.createElement('div')
        div1.className = 'top-header-item'
        div1.innerHTML = `${item.title} 🔽`


        // ------------------------------------------------

        let div3 = document.getElementById('children-header-1')

        // _chil是顶部子菜单列表
        let _chil = item.children

        div1.addEventListener('click', (_e) => {

            if (ACTIVE_TOP_HEADER) {
                ACTIVE_TOP_HEADER.classList.remove('active')
            }

            ACTIVE_TOP_HEADER = div1
            div1.classList.add('active')


            div3.innerHTML = ''
            _chil.forEach((_ii, _index) => {
                let div2 = document.createElement('div')
                div2.className = 'children-header-item1'
                div2.innerHTML = `${_index + 1}. ${_ii.title}`

                div2.addEventListener('click', (ee) => {
                    iframe1.src = _ii.src1
                })
                // div1.appendChild(div2)
                div3.appendChild(div2)
            })
        })



        topheader1.appendChild(div1)


    })

}

initMenu1()

