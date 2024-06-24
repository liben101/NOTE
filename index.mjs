const MENUS_1 = [
    {
        icon: ``,
        title: '和利时DCS',
        children: [
            {
                icon: ``,
                title: '主控制器',
                src1: './drawio/和利时_主控制器单元1.drawio.html'
            }
        ]
    }, {
        icon: ``,
        title: 'MES相关',
        children: [
            {
                icon: ``,
                title: 'MES上下游',
                src1: './drawio/MES上下游1.drawio.html'
            },
            {
                icon: ``,
                title: 'SQL相关',
                src1: './drawio/SQL相关.drawio.html'
            }
        ]
    }, {
        icon: ``,
        title: '中控DCS',
        children: [
            {
                icon: ``,
                title: '基本',
                src1: './drawio/中控/组态软件基本.drawio.html'
            }, {
                icon: ``,
                title: 'PID功能块的对比',
                src1: './drawio/中控/PID功能块的对比.drawio.html'
            },

        ]
    },
]

var ACTIVE_TOP_HEADER = null

var iframe1 = document.getElementById('iframe1')

function initMenu1() {
    /**
             * 
             * 初始化第一层menu
             * 
             * **/

    let topheader1 = document.getElementById('top-header-1')

    // let menu1html = ``
    MENUS_1.forEach(item => {
        // menu1html += `<div class="top-header-item">${item.title} 🔽</div>`


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

    // topheader1.innerHTML = menu1html

    // -----------------------------------

    // let topHeaderItems = document.querySelectorAll('.top-header-item')

    // let html2 = ``

    // html2 += `<div class="top-header-item-2">和利时DCS 🔽</div>`

    // topHeaderItems.forEach(_item=>{
    //     _item.addEventListener('click',(e)=>{

    //     })
    // })
}

initMenu1()