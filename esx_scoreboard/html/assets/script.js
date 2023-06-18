window.addEventListener('message', function(event) {
    switch(event.data.action){
        case 'toggle':
            if (event.data.state) {
                $('#page').fadeIn('fast');
            } else {
                $('#page').fadeOut('fast');
            }
            break;
        case 'update':
            Object.entries(event.data.data).forEach(([type, info]) => {
                if (type == "players") {
                    $(`.${type}`).html(`Graczy: <b>${info}</b>`);
                } else {
                    if (type != "admins") {
                        if (type != "job" && type != "hiddenjob") {
                            if (info > 0) {
                                $(`.${type}`).css("color", "yellowgreen");
                            } else {
                                $(`.${type}`).css("color", "crimson");
                            }
                        }
                        if (type == "police") {
                            if (info > 2) {
                                $(`.sklepy`).css("color", "yellowgreen");
                                $('.sklepy').html("✓");
                            } else {
                                $(`.sklepy`).css("color", "crimson");
                                $('.sklepy').html("x");
                            }
                            if (info > 4) {
                                $(`.jubiler`).css("color", "yellowgreen");
                                $('.jubiler').html("✓");
                            } else {
                                $(`.jubiler`).css("color", "crimson");
                                $('.jubiler').html("x");
                            }
                            if (info > 10) {
                                $(`.yacht`).css("color", "yellowgreen");
                                $('.yacht').html("✓");
                            } else {
                                $(`.yacht`).css("color", "crimson");
                                $('.yacht').html("x");
                            }
                            if (info > 5) {
                                $(`.bank`).css("color", "yellowgreen");
                                $('.bank').html("✓");
                            } else {
                                $(`.bank`).css("color", "crimson");
                                $('.bank').html("x");
                            }
                        } 
                        $(`.${type}`).html(info);
                    } else {
                        //$(`.${type}`).html(`Administracja: <b style='color:#24c6dc;'>${info}</b>`)
                    }
                }
            });
            break;
    }
})