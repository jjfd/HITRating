//general configurations
var ROOT = "/";

//general functions
function htmlEscape(str) {
    return String(str)
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&lsquo;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/&/g, '&amp;');
}

function htmlUnEscape(str) {
    return String(str)
            .replace(/&quot;/g, '"')
            .replace(/&lsquo;/g, "'")
            .replace(/&lt;/g, '<')
            .replace(/&gt;/g, '>')
            .replace(/&amp;/g, '&');
}

function xmlEscape(str) {
    return String(str)
            .replace(/&/g, '&amp;')
            .replace(/"/g, '&quot;')
            .replace(/'/g, '&lsquo;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;');
}

function xmlUnEscape(str) {
    return String(str)
            .replace(/&amp;/g, '&')
            .replace(/&quot;/g, '"')
            .replace(/&lsquo;/g, "'")
            .replace(/&lt;/g, '<')
            .replace(/&gt;/g, '>');
}

function encodeUri(uri) {
    return uri.replace(/#/g, '%23').replace(/&amp;/g, '&').replace(/&/g, '%26').replace(/\+/g, '%2B').replace(/\"/g, '%22').replace(/\'/g, '%27').replace(/\//g, '%2F');
}

function decodeUri(uri) {
    return uri.replace(/&amp;/g, '&').replace(/#/g, '%23');
}

$.print = function (article) {
    if (article == null) {
        return false;
    }

    if ($("body .print_container").length) {
        $("body .print_container").empty();
    }
    else {
        $("body").append("<div class='print_container'></div>")
    }

    $("body .print_container").html($(article).html());
    window.print();
}

$.centerPopup = function (popup) {
    $("#popup_cover").show();

    if ($(".popup:visible").length) {
        $(".popup:visible").slideUp("normal", function () {
            $(popup).slideDown("normal");
        });
    }
    else {
        $(popup).slideDown("normal");
    }
}

$.fadePopup = function (popup, fn) {
    $("#popup_cover").hide();
    $(popup).slideUp("normal", fn);
}

$.centerFlashPopup = function (popup) {
    $(popup).fadeIn('normal', function () {
        $(this).animate({ "opacity": 1 }, "slow").fadeOut(2000);
    });
}

$.disableButtons = function (buttons) {
    $(buttons).find("a").addClass("disabled");
    $(buttons).find("input").addClass("disabled");
    $(buttons).append("<div class='cover'>&nbsp;</div>");
}

$.enableButtons = function (buttons) {
    $(buttons).find("a").removeClass("disabled");
    $(buttons).find("input").removeClass("disabled");
    $(buttons).find(".cover").remove();
}

$(function () {
    //list table 
    $(".list_table tr:even").addClass("even");

    $(".list_table tr").mouseover(function () {
        $(this).children("td").addClass("over");
    }).mouseout(function () {
        $(this).children("td").removeClass("over");
    });

    //module
    $('.module .tabs .tab').live('click', function () {
        var show = $(this).attr('show');

        if (show && ($(this).parents('.tabs').siblings().children('.page:visible').attr('page') != show)) {
            $(this).addClass('selected').siblings().removeClass('selected');
            $(this).parents('.tabs').siblings().children('.page:visible').hide();
            $(this).parents('.tabs').siblings().children('.page[page=' + show + ']').show();
        }
    });

    var moduletabGroups = $(".module .tabs");
    if (moduletabGroups.length > 0) {
        for (var i = 0; i < moduletabGroups.length; i++) {
            var tabs = moduletabGroups.eq(i).children(".tab");
            if (tabs.length > 0) {
                tabs.eq(0).click();

            }
        }
    }

    $('.popup .close').live('click', function () {
        $.fadePopup($(this).parents(".popup"));
    });

    $(".popup .cancel").live("click", function () {
        $(this).parents(".popup").children(".close").click();
    });

    //one click buttons
    $(".one_click_buttons a").live("click", function () {
        $.disableButtons($(this).parent());
    });

    $(".one_click_buttons input:button").live("click", function () {
        $.disableButtons($(this).parent());
    });

    $(".one_click_buttons input:submit").live("click", function () {
        $.disableButtons($(this).parent());
    });

    //mini_search
    $("input.tip_search").live("click", function () {
        $(this).val("").removeClass("tip_search");
    })

    $("input.mini_search").live("keyup", function (e) {
        if (e.keyCode == 13) {
            window.location.href = encodeURI($(this).attr("action")) + encodeURIComponent($(this).val());
        }
    })

    //tip_input
    $("input.tip_input").live("focus", function () {
        $(this).removeClass("tip_input").val("");
    })

    //toggle read
    $(".toggle_read .toggle").live("click", function () {
        var toggleContents = $(this).parents(".toggle_read").find(".toggle_content").toggleClass("hidden");

        if ($(this).hasClass("one_click_toggle")) {
            $(this).hide();
        }
    })

    //ajax search suggestions
    var selectedItem = -1;
    $('.ajax_search .ajax_input_title').live('keyup', function (event) {
        switch (event.keyCode) {
            case 13: //选中某个选项
                if (selectedItem >= 0) {
                    $(this).siblings('.ajax_suggestions').find('.option:eq(' + selectedItem + ')').mousedown();
                }
                $(this).siblings('.ajax_suggestions').empty();
                selectedItem = -1;
                break;
            case 38: //
                var ajaxSelectors = $(this).siblings('.ajax_suggestions').find(".options");
                var matches = $(ajaxSelectors).children('.option').length;
                selectedItem--;
                if (selectedItem < 0) {
                    selectedItem = -1;
                }

                $(ajaxSelectors).children('.option').removeClass('selected');
                if (selectedItem >= 0) {
                    $(ajaxSelectors).children('.option:eq(' + selectedItem + ')').addClass('selected');
                }

                break;
            case 40:
                var ajaxSelectors = $(this).siblings('.ajax_suggestions').find(".options");
                var matches = $(ajaxSelectors).children('.option').length;

                selectedItem++;
                if (selectedItem >= matches) {
                    selectedItem = matches - 1;
                }

                $(ajaxSelectors).children('.option').removeClass('selected');
                $(ajaxSelectors).children('.option:eq(' + selectedItem + ')').addClass('selected');

                break;
            case 37:
                break;
            case 39:
                break;
            default:
                var thisInput = this;
                $.ajax(
                        {
                            url: encodeURI($(this).parents('.ajax_search').attr('url') + $(this).val()),
                            dataType: "json",
                            success: function (data) {
                                var opts = "";
                                for (var i = 0; i < data.Entities.length; i++) {
                                    opts += "<div class='option' sid='" + data.Entities[i].Id + "'>" + data.Entities[i].Title + "</div>";
                                }

                                if (opts.length) {
                                    opts = "<div class='options'>" + opts + "</div>"
                                }

                                $(thisInput).siblings('.ajax_suggestions').html(opts);

                            },
                            error: function () {
                                $(thisInput).siblings('.ajax_suggestions').empty();
                            }
                        }
                    );

                selectedItem = -1;
                $(this).siblings('.ajax_input_sid').val("");
        }
    }).live('focus', function () {
        var thisInput = this;
        $.ajax(
            {
                url: encodeURI($(this).parents('.ajax_search').attr('url') + $(this).val()),
                dataType: "json",
                success: function (data) {
                    var opts = "";
                    for (var i = 0; i < data.Entities.length; i++) {
                        opts += "<div class='option' sid='" + data.Entities[i].Id + "'>" + data.Entities[i].Title + "</div>";
                    }

                    if (opts.length) {
                        opts = "<div class='options'>" + opts + "</div>"
                    }
                    $(thisInput).siblings('.ajax_suggestions').html(opts);
                },
                error: function () {
                    $(thisInput).siblings('.ajax_suggestions').empty();
                }
            }
        );

        selectedItem = -1;
        $(this).siblings('.ajax_input_sid').val("");
    }).live('blur', function () {
        $(this).siblings('.ajax_suggestions').empty();
    });

    $('.ajax_suggestions .option').live('mousedown', function () {
        $(this).parents('.ajax_suggestions').siblings('.ajax_input_title').val($(this).text());
        $(this).parents('.ajax_suggestions').siblings('.ajax_input_sid').val($(this).attr('sid'));
    }).live("mouseover", function () {
        $(this).siblings().removeClass('selected');
        $(this).addClass('selected');
    });

    $(".printable .print").live("click", function () {
        $.print($(this).parents(".printable"));
    })

    $(".star_input:not([disabled='disabled'])").find(".star").live("click", function (e) {
        
        $(this).addClass("selected");
        $(this).prevAll().addClass("selected");
        $(this).nextAll().removeClass("selected");

        $(this).parents(".star_input").find("input").val($(this).prevAll().length + 1);
    })
})

/* HitRating api panels configurations */
var HitRatingApiRoot = "/";
var TboxTemplate = '<div class="tbox"><aside></aside><article><h3></h3><section></section><nav></nav></article></div>';
var MiniTboxTemplate = '<div class="mini_tbox"><article></article><nav></nav></div>';
var ToggleReadTemplate = '<div class="toggle_read"><a class="toggle float_right" title="展开/收起">&#8645</a><div class="toggle_content"></div><div class="toggle_content hidden printable"></div></div>'

/* share to sina weibo */
$.share = function (title, url) {
    return '<a class="weibo_share" href="http://service.weibo.com/share/share.php?title=' + encodeUri(title) + '&url=http%3A%2F%2Ftword-tapp.com' + encodeUri(url) + '&appkey=3985917733&pic=&ralateUid=&language=&sudaref=hits.sinajs.cn" target="_blank" title="分享到微博"><img src="' + TwordApiRoot + 'Images/sina_share.jpg" class="icon" alt="分享到微博"></a>';
}

/* date time */
$.renderDateTime = function (str) {
    if (typeof str != "string") {
        return null;
    }

    var dateTimeSplits = str.split(" ");

    var dateSplits;
    if (dateTimeSplits[0].indexOf("/") > 0) {
        dateSplits = dateTimeSplits[0].split("/");
    }
    else if (dateTimeSplits[0].indexOf("-") > 0) {
        dateSplits = dateTimeSplits[0].split("-");
    }
    else if (dateTimeSplits[0].indexOf(".") > 0) {
        dateSplits = dateTimeSplits[0].split(".");
    }
    else {
        return null;
    }

    var timeSplits = dateTimeSplits[1].split(":");
    var dateTime = new Date();
    dateTime.setFullYear(dateSplits[0], dateSplits[1] - 1, dateSplits[2]);
    dateTime.setHours(timeSplits[0], timeSplits[1], timeSplits[2]);

    var today = new Date();
    today.setHours(0, 0, 0);
    var yesterday = new Date();
    yesterday.setDate(today.getDate() - 1);
    var thisYear = new Date();
    thisYear.setFullYear(thisYear.getFullYear(), 0, 1);
    thisYear.setHours(0, 0, 0);

    var dateTimeString = "";
    if (dateTime > today) {
        dateTimeString += "今天";
    }
    else if (dateTime > yesterday) {
        dateTimeString += "昨天";
    }
    else if (dateTime > thisYear) {
        dateTimeString += dateSplits[1] + "-" + dateSplits[2];
    }
    else {
        dateTimeString += dateSplits[0] + "-" + dateSplits[1] + "-" + dateSplits[2];
    }

    dateTimeString += " " + timeSplits[0] + ":" + timeSplits[1];

    return dateTimeString;
}

/* taction */
$.renderTactions = function (options) {
    try {
        var actions = $("<div></div>");

        if (options != null) {
            for (var i = 0; i < options.length; i++) {
                actions.append('<a href="#taction" class="taction" object="' + options[i].Object + '" taction_id="' + options[i].ActionId + '" taction_type="' + options[i].ActionType + '" method="' + options[i].HttpMethod + '" api="' + options[i].Uri + '" object_id="' + options[i].ObjectId + '" title="' + options[i].ActionDefinition + '">' + options[i].ActionName + '</a>');
            }
        }

        return actions.html();
    }
    catch (e) {
        throw e;
    }
}

$.renderDescription = function (description, maxLength) {
    try {
        if (maxLength > 0) {
            return description.substr(0, maxLength) + "...";
        }
        else {
            return description.replace(/\n/g, "<br />");
        }
    }
    catch (e) {
        return "";
    }
}

//vendor
$.renderVendor = function (entity) {
    try {
        var tbox = $(TboxTemplate);

        tbox.addClass("vendor_instant").attr("object_id", entity.Id);
        tbox.find("aside").append("<a href='#taction' class='taction' object='Vendor' object_id='" + entity.Id + "' taction_id='Read_Vendor' taction_type='2' method='GET' api='" + HitRatingApiRoot + "Api/Vendor/" + entity.Id + "' title='查看" + entity.Title + "的详细信息'><img class='photo' src='" + entity.Logo + "' alt='' /></a>");
        tbox.find("article > h3").append(entity.Title);

        var toggleRead = $(ToggleReadTemplate);
        toggleRead.find(".toggle_content").eq(0).append("<label>电话：</label><span class='value phone'>" + entity.Phone + "</span>&nbsp;")
                                                .append("<label>400电话：</label><span class='value phone'>" + entity.Phone_400 + "</span>&nbsp;")
                                                .append("<label>800电话：</label><span class='value phone'>" + entity.Phone_800 + "</span>")
                                                .append("<br /><label>地址：</label><span class='value address'>" + entity.Address + "</span>。")
        toggleRead.find(".toggle_content").eq(1).append('<p><label>公司主页：</label><span class="value url"><a target="_blank" href="' + entity.HomePage + '">' + entity.HomePage + '</a></span></p>')
                                                .append('<p><label>办公电话：</label><span class="value phone">' + entity.Phone + '</span></p>')
                                                .append('<p><label>400电话：</label><span class="value phone">' + entity.Phone_400 + '</span></p>')
                                                .append('<p><label>800电话：</label><span class="value phone">' + entity.Phone_800 + '</span></p>')
                                                .append('<p><label>传真：</label><span class="value fax">' + entity.Fax + '</span></p>')
                                                .append('<p><label>邮箱：</label><span class="value email">' + entity.Email + '</span></p>')
                                                .append('<p><label>地址：</label><span class="value">' + entity.Address + '</span></p>')
                                                .append('<div><label>公司简介：</label><p class="value">' + $.renderDescription(entity.Description) + '</p></div>');
        tbox.find("article > section").append(toggleRead);

        tbox.find("article > nav").append($.renderTactions(entity.Options))
                                  .append('<a href="#taction" class="taction" object="Vendor" object_id="' + entity.Id + '" taction_type="2" taction_id="Read_Vendor" method="GET" api="/Api/Vendor/' + entity.Id + '" title="查看详情">&#8674</a>');

        return tbox;
    }
    catch (e) {
        throw e;
    }
}
//--vendor

//category
$.renderCategory = function (entity) {
    try {
        var tbox = $(TboxTemplate);

        tbox.addClass("category_instant").attr("object_id", entity.Id);
        tbox.find("aside").append("<a href='#taction' class='taction' object='Category' object_id='" + entity.Id + "' taction_id='Read_Category' taction_type='2' method='GET' api='" + HitRatingApiRoot + "Api/Category/" + entity.Id + "' title='查看" + entity.Title + "的详细信息'>" + entity.Abbreviation + "</a>");
        tbox.find("article > h3").append(entity.Title);

        var toggleRead = $(ToggleReadTemplate);
        toggleRead.find(".toggle_content").eq(0).append("<label>英文简称：</label><span class='value abbreviation'>" + entity.Abbreviation + "</span>&nbsp;")
                                                .append("<label>中文名称：</label><span class='value'>" + entity.ChineseTitle + "</span>。")
        toggleRead.find(".toggle_content").eq(1).append('<p><label>英文简称：</label><span class="value abbreviation">' + entity.Abbreviation + '</span></p>')
                                                .append('<p><label>中文名称：</label><span class="value">' + entity.ChineseTitle + '</span></p>')
                                                .append('<div><label>简介：</label><p class="value">' + $.renderDescription(entity.Description) + '</p></div>');
        tbox.find("article > section").append(toggleRead);

        tbox.find("article > nav").append($.renderTactions(entity.Options))
                                  .append('<a href="#taction" class="taction" object="Category" object_id="' + entity.Id + '" taction_type="2" taction_id="Read_Category" method="GET" api="/Api/Category/' + entity.Id + '" title="查看详情">&#8674</a>');

        return tbox;
    }
    catch (e) {
        throw e;
    }
}
//--category  

//product
$.renderProduct = function (entity) {
    try {
        var tbox = $(TboxTemplate);

        tbox.addClass("product_instant").attr("object_id", entity.Id);
        tbox.find("aside").append("<a href='#taction' class='taction' object='Product' object_id='" + entity.Id + "' taction_id='Read_Product' taction_type='2' method='GET' api='" + HitRatingApiRoot + "Api/Product/" + entity.Id + "' title='查看" + entity.Title + "的详细信息'><img src='" + entity.Logo + "' /></a>");
        tbox.find("article > h3").append(entity.Title);

        var toggleRead = $(ToggleReadTemplate);
        toggleRead.find(".toggle_content").eq(0).append("<label>供应商：</label><span class='value'><a href='#taction' class='taction' object='Vendor' object_id='" + entity.Vendor.Id + "' taction_type='2' taction_id='Read_Vendor' method='GET' Api='/Api/Vendor/" + entity.Vendor.Id + "' title='查看详情'>" + entity.Vendor.Title + "</span><br />")
                                                .append("<label>版本号：</label><span class='value version'>" + entity.Version + "</span>&nbsp;")
                                                .append("<label>产品类别：</label><span class='value'>" + (entity.Category == null ? null : "<a href='#taction' class='taction' object='Category' object_id='" + entity.Category.Id + "' taction_type='2' taction_id='Read_Category' method='GET' Api='/Api/Category/" + entity.Category.Id + "' title='查看详情'>" + entity.Category.Title + "</span>") + "&nbsp;")
                                                .append("<label>发布日期：</label><span class='value date'>" + entity.Published + "</span>。");
        toggleRead.find(".toggle_content").eq(1).append("<p><label>供应商：</label><span class='value'><a href='#taction' class='taction' object='Vendor' object_id='" + entity.Vendor.Id + "' taction_type='2' taction_id='Read_Vendor' method='GET' Api='/Api/Vendor/" + entity.Vendor.Id + "' title='查看详情'>" + entity.Vendor.Title + "</span></p>")
                                                .append('<p><label>版本号：</label><span class="value">' + entity.Version + '</span></p>')
                                                .append("<p><label>产品类别：</label><span class='value'>" + (entity.Category == null ? null : "<a href='#taction' class='taction' object='Category' object_id='" + entity.Category.Id + "' taction_type='2' taction_id='Read_Category' method='GET' Api='/Api/Category/" + entity.Category.Id + "' title='查看详情'>" + entity.Category.Title + "</span>") + "</p>")
                                                .append('<p><label>发布日期：</label><span class="value date">' + entity.Published + '</span></p>')
                                                .append('<p><label>前一版本号：</label><span class="value version">' + entity.PreVersion + '</span></p>')
                                                .append('<p><label>售前电话：</label><span class="value">' + entity.PhonePreSale + '</span></p>')
                                                .append('<p><label>售后电话：</label><span class="value">' + entity.PhoneAfterSale + '</span></p>')
                                                .append('<div><label>简介：</label><p class="value">' + $.renderDescription(entity.Description) + '</p></div>');
        tbox.find("article > section").append(toggleRead);

        tbox.find("article > nav").append($.renderTactions(entity.Options))
                                  .append('<a href="#taction" class="taction" object="Product" object_id="' + entity.Id + '" taction_type="2" taction_id="Read_Product" method="GET" api="/Api/Product/' + entity.Id + '" title="查看详情">&#8674</a>')
                                  .prepend('<a href="#taction" class="taction" object="Review" object_id="' + entity.Id +'" taction_type="1" taction_id="Create_Review_Of_Product" method="POST" api="/Api/Reviews?ProductId=' + entity.Id + '" title="发表对本HIT产品的评价">评价</a>');

        return tbox;
    }
    catch (e) {
        throw e;
    }
}
//--product

//review
$.renderReview = function (entity) {
    try {
        var tbox = $(TboxTemplate);

        tbox.addClass("review_instant").attr("object_id", entity.Id);
        tbox.find("aside").append("<a href='#taction' class='taction' object='Review' taction_id='Search_Review' taction_type='5' method='GET' api='" + HitRatingApiRoot + "Api/Reviews?Creator=" + entity.Creator.UserName + "' title='查询" + entity.Creator.UserName + "发布的产品评价'><img src='" + entity.Creator.PhotoUrl + "' /></a>");
        tbox.find("article > h3").append("<a href='#taction' class='taction' object='Review' taction_id='Search_Review' taction_type='5' method='GET' api='" + HitRatingApiRoot + "Api/Reviews?Creator=" + entity.Creator.UserName + "' title='查询" + entity.Creator.UserName + "发布的产品评价'>" + entity.Creator.UserName + "</a>" + "@" + entity.Product.Title + "的评价");

        var toggleRead = $(ToggleReadTemplate);
        toggleRead.find(".toggle_content").eq(0).append("<span class='value star_input' disabled='disabled'><span class='stars'><span class='star'>★</span>&nbsp;<span class='star'>★</span>&nbsp;<span class='star'>★</span>&nbsp;<span class='star'>★</span>&nbsp;<span class='star'>★</span></span><input type='hidden' /></span>&nbsp;")
                                                .append("<span class='value'>" + $.renderDescription(entity.Details, 140) + "</span>");

        toggleRead.find(".toggle_content").eq(1).append("<p><span class='value star_input' disabled='disabled'><span class='stars'><span class='star'>★</span>&nbsp;<span class='star'>★</span>&nbsp;<span class='star'>★</span>&nbsp;<span class='star'>★</span>&nbsp;<span class='star'>★</span></span><input type='hidden' /></span></p>")
                                                .append("<div class='rated_aspects'></div>")
                                                .append("<div class='value'>" + $.renderDescription(entity.Details) + "</div>");

        var starGroup1 = toggleRead.find(".star_input").eq(0).find(".star");
        for (var i = 0; i < entity.Rate; i++) {
            starGroup1.eq(i).addClass("selected");
        }

        var starGroup2 = toggleRead.find(".star_input").eq(1).find(".star");
        for (var i = 0; i < entity.Rate; i++) {
            starGroup2.eq(i).addClass("selected");
        }

        var ratedAspects = toggleRead.find(".rated_aspects");
        try {
            var ras = entity.RatedAspects;

            for (var i = 0; i < ras.length; i++) {
                var ratedAspect = $("<p class='rated_aspect small gray right' aspect_id='" + ras[i].Id + "'><span class='float_left'>" + ras[i].Title + "</span><span class='value star_input' disabled='disabled'><span class='stars'><span class='star'>★</span><span class='star'>★</span><span class='star'>★</span><span class='star'>★</span><span class='star'>★</span></span><input type='hidden' /></span></p>");

                var starGroupOfRA = ratedAspect.find(".star");
                for (var j = 0; j < ras[i].Rate; j++) {
                    starGroupOfRA.eq(j).addClass("selected");
                }

                ratedAspects.append(ratedAspect);
            }
        }
        catch (e) {
            ratedAspects.empty();
        }

        tbox.find("article > section").append(toggleRead);

        var dateTime = $("<p class='created_and_updated gray small'></p>");
        dateTime.append("<span>创建于" + $.renderDateTime(entity.Created) + "</span>");
        if (entity.Updated != null && entity.Updated != "") {
            dateTime.append("，<span>" + $.renderDateTime(entity.Updated) + "做了最新修改</span>");
        }
        tbox.find("article > section").append(dateTime);

        //vote message
        if (entity.Vote != null) {
            if (entity.Vote != "not_allowed") {
                tbox.find("article > section").append("<p class='gray small line'>你已经于" + $.renderDateTime(entity.Vote.Created) + "投票" + (entity.Vote.Supportive ? "<span class='red'>支持</span>" : "<span class='green'>反对</span>") + "这条评价。</p>");
            }
        }
        else {
            tbox.find("article > section").append('<p class="vote_message small line"><span class="gray message">你对本HIT产品评价的投票：</span>&nbsp;<span class="buttons one_click_buttons"><a href="#taction" class="taction" object="Vote" object_id="' + entity.Id + '" taction_type="1" taction_id="Support" method="POST" api="/Api/Votes?ReviewId=' + entity.Id + '&Supportive=true" title="支持">支持</a>&nbsp;<a href="#taction" class="taction" object="Vote" object_id="' + entity.Id + '" taction_type="1" taction_id="Oppose" method="POST" api="/Api/Votes?ReviewId=' + entity.Id + '&Supportive=false" title="反对">反对</a></span></p>');
        }

        tbox.find("article > nav").append($.renderTactions(entity.Options))
                                  .append('<a href="#taction" class="taction" object="Review" object_id="' + entity.Id + '" taction_type="2" taction_id="Read_Review" method="GET" api="/Api/Review/' + entity.Id + '" title="查看详情">&#8674</a>')
                                  .prepend('<a href="#taction" class="taction" object="Product" object_id="' + entity.Product.Id + '" taction_type="2" taction_id="Read_Product" method="GET" api="/Api/Product/"' + entity.Product.Id + ' title="查看产品详情">产品详情</a>');

        return tbox;
    }
    catch (e) {
        throw e;
    }
}
//--review 

//review
$.renderNews = function (entity) {
    try {
        var tbox = $(TboxTemplate);

        tbox.addClass("review_instant").addClass("news_instant").attr("object_id", entity.Id);
        tbox.find("aside").append("<a href='#taction' class='taction' object='News' taction_id='Search_News' taction_type='5' method='GET' api='" + HitRatingApiRoot + "Api/News?Creator=" + entity.Creator.UserName + "' title='查询" + entity.Creator.UserName + "发布的产品资讯'><img src='" + entity.Creator.PhotoUrl + "' /></a>");
        tbox.find("article > h3").append("<a href='#taction' class='taction' object='News' taction_id='Search_News' taction_type='5' method='GET' api='" + HitRatingApiRoot + "Api/Newss?Creator=" + entity.Creator.UserName + "' title='查询" + entity.Creator.UserName + "发布的产品评价'>" + entity.Creator.UserName + "</a>" + "@" + entity.Product.Title + "的资讯");

        var toggleRead = $(ToggleReadTemplate);
        toggleRead.find(".toggle_content").eq(0).append("<span class='value'>" + $.renderDescription(entity.Details, 140) + "</span>");

        toggleRead.find(".toggle_content").eq(1).append("<div class='value'>" + $.renderDescription(entity.Details) + "</div>");

        tbox.find("article > section").append(toggleRead);

        var dateTime = $("<p class='created_and_updated gray small'></p>");
        dateTime.append("<span>创建于" + $.renderDateTime(entity.Created) + "</span>");
        if (entity.Updated != null && entity.Updated != "") {
            dateTime.append("，<span>" + $.renderDateTime(entity.Updated) + "做了最新修改</span>");
        }
        tbox.find("article > section").append(dateTime);

        tbox.find("article > nav").append($.renderTactions(entity.Options))
                                  .append('<a href="#taction" class="taction" object="Review" object_id="' + entity.Id + '" taction_type="2" taction_id="Read_Review" method="GET" api="/Api/Review/' + entity.Id + '" title="查看详情">&#8674</a>')
                                  .prepend('<a href="#taction" class="taction" object="Product" object_id="' + entity.Product.Id + '" taction_type="2" taction_id="Read_Product" method="GET" api="/Api/Product/"' + entity.Product.Id + ' title="查看产品详情">产品详情</a>');

        return tbox;
    }
    catch (e) {
        throw e;
    }
}
//--review 

//product info
$.renderProductInfo = function (entity) {
    try {
        if (entity.Type == 1) {
            return $.renderReview(entity)
        }
        else if (entity.Type == 2) {
            return $.renderNews(entity);
        }
        else {
            return null;
        }
    }
    catch (e) {
        throw e;
    }
}
//--prodcut info

//comment
$.renderComment = function (entity) {
    try {
        var tbox = $(TboxTemplate);

        tbox.addClass("comment_instant").attr("object_id", entity.Id);
        tbox.find("aside").append("<a href='#taction' class='taction' object='Comment' taction_id='Search_Comment' taction_type='5' method='GET' api='" + HitRatingApiRoot + "Api/Commments?Creator=" + entity.Creator.UserName + "' title='查询" + entity.Creator.UserName + "发表的评论'><img src='" + entity.Creator.PhotoUrl + "' /></a>");
        tbox.find("article > h3").append("<a href='#taction' class='taction' object='Comment' taction_id='Search_Comment' taction_type='5' method='GET' api='" + HitRatingApiRoot + "Api/Comments?Creator=" + entity.Creator.UserName + "' title='查询" + entity.Creator.UserName + "发表的评论'>" + entity.Creator.UserName + "</a>");

        var toggleRead = $(ToggleReadTemplate);
        toggleRead.find(".toggle_content").eq(0).append("<span class='value'>" + $.renderDescription(entity.Details, 140) + "</span>");
        toggleRead.find(".toggle_content").eq(1).append("<div class='value'>" + $.renderDescription(entity.Details) + "</div>");

        tbox.find("article > section").append(toggleRead);

        var dateTime = $("<p class='created_and_updated gray small'></p>");
        dateTime.append("<span>创建于" + $.renderDateTime(entity.Created) + "</span>");
        if (entity.Updated != null && entity.Updated != "") {
            dateTime.append("，<span>" + $.renderDateTime(entity.Updated) + "做了最新修改</span>");
        }

        tbox.find("article > section").append(dateTime);

        tbox.find("article > nav").append($.renderTactions(entity.Options));
        return tbox;
    }
    catch (e) {
        throw e;
    }
}
//--comment

//aspect
$.renderAspect = function (entity) {
    try {
        var line = $('<div class="line aspect"><p class="float_right attributor"></p></p><p class="title"></p><p class="gray small">[rated <span class="rated_times red"></span> times] contributed by <span class="creator blue"></span> @<span class="created"></span></p></div>');

        line.attr("aspect_id", entity.Id);
        line.find(".attributor").html("<img src='" + entity.Creator.PhotoUrl + "' alt='" + entity.Creator.UserName + "' style='width:2em;height: 2em; padding: 1px;border:1px solid #ddd;opacity:.8;' />");
        line.find(".title").text(entity.Title);
        line.find(".rated_times").text(entity.RatedTimes);
        line.find(".creator").text(entity.Creator.UserName);
        line.find(".created").text($.renderDateTime(entity.Created));

        return line;
    }
    catch (e) {
        throw e;
    }
}
//--aspect