<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
        
        <script type="text/javascript">
            //configurations
            var PanelApiRoot = "/";
            var iam = "<%: Page.User.Identity.Name %>";
        </script>
        <div id="user_control_panels">
            <script type="text/javascript">
                $(".taction[object='Session'][taction_type='1']").live("click", function () {
                    $("#account_log_on").attr("redirect_to", $(this).attr("redirect_to"));
                    
                    $.centerPopup($("#account_log_on"));
                });

                $(".taction[object='Session'][taction_type='4']").live("click", function () {
                    var redirectTo = $(this).attr("redirect_to");

                    $.ajax({
                        type: "DELETE",
                        url: PanelApiRoot + "Api/Account/" + "<%: Page.User.Identity.Name %>" + "/Session",
                        dataType: "json",
                        success: function () {
                            window.location.href = redirectTo;
                        },
                        error: function (jqXHR) {
                            $.miniErrorAjaxResult("钥匙拿错了!? 请重试");
                        }
                    });

                    return false;
                });

                $(".taction[object='Account'][taction_type='1']").live("click", function () {
                    $("#account_register").attr("redirect_to", $(this).attr("redirect_to")).attr("no_redirect", $(this).attr("no_redirect"));

                    $.centerPopup($("#account_register"));
                });
            </script>
            <div id="account_log_on" class="module popup">
                <script type="text/javascript">
                    $(function () {
                        $("#account_log_on input[name='Password']").keyup(function (e) {
                            if (e.keyCode == 13) {
                                $("#account_log_on input:submit").click();
                            }
                        });

                        $("#account_log_on input:submit").click(function () {
                            var redirectTo = $(this).parents("#account_log_on").attr("redirect_to");
                            var noRedirect = $(this).parents("#account_log_on").attr("no_redirect") == "true" ? true : false;

                            $.ajax({
                                type: "POST",
                                url: PanelApiRoot + "Api/Account/" + $("#account_log_on input[name='UserName']").val() + "/Session",
                                data: { Password: $("#account_log_on input[name='Password']").val(), RememberMe: $("#account_log_on input[name='RememberMe']").is(":checked") },
                                dataType: "json",
                                success: function () {
                                    if (!noRedirect) {
                                        if (redirectTo == null) {
                                            location.reload();
                                        }
                                        else {
                                            window.location.href = redirectTo;
                                        }
                                    }
                                    else {
                                        $.miniSuccessAjaxResult("登录成功");
                                        $.fadePopup($("#account_log_on"));
                                    }
                                },
                                error: function (jqXHR) {
                                    if ($("#account_log_on .validation_error").length < 1) {
                                        $("#account_log_on").prepend("<div class='validation_error line'>用户名或密码错误</div>");
                                    }

                                    $.enableButtons($("#account_log_on .buttons"));
                                }
                            });
                        });
                    })
                </script>
                <h3 class="caption">登录</h3>
                <a class="close">x</a>
                <div class="pages">
                    <div class="line">
                        <label>用户</label>
                        <input name="UserName" />
                    </div>
                    <div class="line">
                        <label>密码</label>
                        <input type="password" name="Password" />
                    </div>
                    <div class="line">
                        <input type="checkbox" name="RememberMe" checked="checked" />
                        <label>记住我</label>
                    </div>
                </div>
                <div class="bottom left">
                    <div class="buttons one_click_buttons">
                        <input type="submit" value="登录" />
                    </div>
                </div>
            </div>

            <div id="account_register" class="module popup">
                <script type="text/javascript">
                    $(function () {
                        $("#account_register input:submit").click(function () {
                            var redirectTo = $(this).parents("#account_register").attr("redirect_to");

                            $("#account_register .validation_error").remove();

                            var flag = true;
                            if ($("#account_register input[name='UserName']").val().length < 1) {
                                if ($("#account_register .validation_error").length < 1) {
                                    $("#account_register").prepend("<div class='validation_error line'>请填写用户名</div>");
                                }
                                else {
                                    $("#account_register .validation_error").text("请填写用户名");
                                }

                                flag = false;
                            }

                            if ($("#account_register input[name='Password']").val().length < 6) {
                                if ($("#account_register .validation_error").length < 1) {
                                    $("#account_register").prepend("<div class='validation_error line'>密码不能少于6个字符</div>");
                                }
                            }

                            if ($("#account_register input[name='Password']").val() != $("#account_register input[name='PasswordConfirm']").val()) {
                                if ($("#account_register .validation_error").length < 1) {
                                    $("#account_register").prepend("<div class='validation_error line'>两次密码输入不一致</div>");
                                }

                                flag = false;
                            }

                            if (flag) {
                                $.disableButtons($("#account_register .buttons"));

                                $.ajax({
                                    type: "POST",
                                    url: PanelApiRoot + "Api/Accounts",
                                    data: { UserName: $("#account_register input[name='UserName']").val(), Email: $("#account_register input[name='Email']").val(), Password: $("#account_register input[name='Password']").val() },
                                    dateType: "json",
                                    success: function (data) {
                                        if (redirectTo == null) {
                                            location.reload();
                                        }
                                        else {
                                            window.location.href = redirectTo;
                                        }
                                    },
                                    error: function () {
                                        if ($("#account_register .validation_error").length < 1) {
                                            $("#account_register").prepend("<div class='validation_error line'>注册失败，请重试</div>");
                                        }

                                        $.enableButtons($("#account_register .buttons"));
                                    }
                                })
                            }
                        })
                    })
                </script>
                <h3 class="caption">注册</h3>
                <a class="close">x</a>
                <div class="pages">
                    <div class="line">
                        <label>用户</label>
                        <span class="green">*</span>
                        <input name="UserName" />
                    </div>
                    <div class="line">
                        <label>邮箱</label>
                        <input name="Email" />
                    </div>
                    <div class="line">
                        <label>密码</label>
                        <span class="green">*</span>
                        <input type="password" name="Password" />
                    </div>
                    <div class="line">
                        <label>密码确认</label>
                        <span class="green">*</span>
                        <input type="password" name="PasswordConfirm" />
                    </div>
                </div>
                <div class="bottom buttons left line">
                    <input type="submit" value="注册" />
                </div>
            </div>
        </div>

        <div id="vendor_panels">
            <script type="text/javascript">
                $(function () {
                    $(".taction[object='Vendor'][taction_type='1']").live("click", function () {
                        $("#vendor_create_panel").attr("method", $(this).attr("method")).attr("api", $(this).attr("api"));
                        $("#vendor_create_panel .caption").text($(this).attr("title"));

                        $.centerPopup($("#vendor_create_panel"));
                    });

                    $(".taction[object='Vendor'][taction_type='2']").live("click", function () {
                        window.open(PanelApiRoot + "Vendor/Details/" + $(this).attr("object_id"));
                    });

                    $(".taction[object='Vendor'][taction_type='3']").live("click", function () {
                        $("#vendor_edit_panel").attr("method", $(this).attr("method")).attr("api", $(this).attr("api"));
                        $("#vendor_edit_panel .caption").text($(this).attr("title"));

                        var objectId = $(this).attr("object_id");

                        $.ajax({
                            type: "GET",
                            url: PanelApiRoot + "Api/Vendor/" + objectId,
                            dataType: "json",
                            success: function (data) {
                                var vendor = data.Entity;

                                $("#vendor_edit_panel input[name='Title']").val(vendor.Title);
                                $("#vendor_edit_panel input[name='Logo']").val(vendor.Logo);
                                $("#vendor_edit_panel input[name='HomePage']").val(vendor.HomePage);
                                $("#vendor_edit_panel input[name='Phone']").val(vendor.Phone);
                                $("#vendor_edit_panel input[name='Phone_400']").val(vendor.Phone_400);
                                $("#vendor_edit_panel input[name='Phone_800']").val(vendor.Phone_800);
                                $("#vendor_edit_panel input[name='Fax']").val(vendor.Fax);
                                $("#vendor_edit_panel input[name='Email']").val(vendor.Email);
                                $("#vendor_edit_panel input[name='Address']").val(vendor.Address);
                                $("#vendor_edit_panel textarea[name='Description']").val(vendor.Description);

                                $.centerPopup($("#vendor_edit_panel"));
                            },
                            error: function () {
                                $.miniErrorAjaxResult("供应商信息 #" + objectId + " 不存在");
                            }
                        });
                    });

                    $(".taction[object='Vendor'][taction_type='4']").live("click", function () {
                        var objectId = $(this).attr("object_id");
                        $("#vendor_delete_panel").attr("method", $(this).attr("method")).attr("api", $(this).attr("api")).attr("object_id", objectId);
                        $("#vendor_delete_panel .caption").text($(this).attr("title"));

                        $("#vendor_delete_panel .pages").html("删除 #" + objectId + " 供应商信息吗?");
                        $.centerPopup($("#vendor_delete_panel"));
                    })

                    $(".taction[object='Vendor'][taction_type='5']").live("click", function () {
                        window.open(PanelApiRoot + "/Vendor/Search?Api=" + encodeUri($(this).attr("api")));
                    })
                })
            </script>

            <div id="vendor_create_panel" class="module popup">
                <script type="text/javascript">
                    $(function () {
                        $("#vendor_create_panel input:submit").click(function () {
                            var method = $("#vendor_create_panel").attr("method");
                            var api = $("#vendor_create_panel").attr("api");
                            $.ajax({
                                type: method,
                                url: api,
                                data: { 
                                    Title: $("#vendor_create_panel input[name='Title']").val(), 
                                    Logo: $("#vendor_create_panel input[name='Logo']").val(),
                                    HomePage: $("#vendor_create_panel input[name='HomePage']").val(),
                                    Phone: $("#vendor_create_panel input[name='Phone']").val(),
                                    Phone_400: $("#vendor_create_panel input[name='Phone_400']").val(),
                                    Phone_800: $("#vendor_create_panel input[name='Phone_800']").val(),
                                    Fax: $("#vendor_create_panel input[name='Fax']").val(),
                                    Email: $("#vendor_create_panel input[name='Email']").val(),
                                    Address: $("#vendor_create_panel input[name='Address']").val(),
                                    Description: $("#vendor_create_panel textarea[name='Description']").val(),       
                                },
                                dataType: "json",
                                success: function (data) {
                                    var vendor = data.Entity;
                                    
                                    $("#vendor_create_panel .pages input").val("");
                                    $("#vendor_create_panel .pages textarea").val("");

                                    $.enableButtons($("#vendor_create_panel .buttons"));

                                    $.fadePopup($("#vendor_create_panel"), function () {
                                        $.miniSuccessAjaxResult("发布成功");
                                        $("#vendors .container").prepend($.renderVendor(vendor));
                                    });
                                },
                                error: function () {
                                    $.miniErrorAjaxResult("发布失败");

                                    $.enableButtons($("#vendor_create_panel .buttons"));
                                }
                            });
                        });
                    })
                </script>
                <h3 class="caption">创建供应商信息</h3>
                <a class="close">x</a>
                <div class="pages">
                    <div class="line">
                        <label>公司名<span class="tip">*</span></label>
                        <input name="Title" />
                    </div>
                    <div class="line">
                        <label>Logo</label>
                        <input type="url" name="Logo" />
                    </div>
                    <div class="line">
                        <label>公司主页</label>
                        <input type="url" name="HomePage" />
                    </div>
                    <div class="line">
                        <label>办公电话</label>
                        <input type="phone" name="Phone" />
                    </div>
                    <div class="line">
                        <label>400电话</label>
                        <input type="phone" name="Phone_400" />
                    </div>
                    <div class="line">
                        <label>800电话</label>
                        <input type="phone" name="Phone_800" />
                    </div>
                    <div class="line">
                        <label>传真</label>
                        <input type="phone" name="Fax" />
                    </div>
                    <div class="line">
                        <label>邮箱</label>
                        <input type="phone" name="Email" />
                    </div>
                    <div class="line">
                        <label>公司地址</label>
                        <input name="Address" />
                    </div>
                    <div class="line">
                        <label>公司简介</label>
                        <textarea name="Description"></textarea>
                    </div>
                </div>
                <div class="bottom right">
                    <div class="buttons one_click_buttons">
                        <input type="submit" value="提交" />
                    </div>
                </div>
            </div>

            <div id="vendor_edit_panel" class="module popup">
                <script type="text/javascript">
                    $(function () {
                        $("#vendor_edit_panel input:submit").click(function () {
                            var method = $("#vendor_edit_panel").attr("method");
                            var api = $("#vendor_edit_panel").attr("api");
                            
                            $.ajax({
                                type: method,
                                url: api,
                                data: { 
                                    Logo: $("#vendor_edit_panel input[name='Logo']").val(),
                                    HomePage: $("#vendor_edit_panel input[name='HomePage']").val(),
                                    Phone: $("#vendor_edit_panel input[name='Phone']").val(),
                                    Phone_400: $("#vendor_edit_panel input[name='Phone_400']").val(),
                                    Phone_800: $("#vendor_edit_panel input[name='Phone_800']").val(),
                                    Fax: $("#vendor_edit_panel input[name='Fax']").val(),
                                    Email: $("#vendor_edit_panel input[name='Email']").val(),
                                    Address: $("#vendor_edit_panel input[name='Address']").val(),
                                    Description: $("#vendor_edit_panel textarea[name='Description']").val(),       
                                },
                                dataType: "json",
                                success: function (data) {
                                    var vendor = data.Entity;

                                    $("#vendor_edit_panel .pages input").val("");
                                    $("#vendor_edit_panel .pages textarea").val("");

                                    $.enableButtons($("#vendor_edit_panel .buttons"));

                                    $.fadePopup($("#vendor_edit_panel"), function () {
                                        $.miniSuccessAjaxResult("修改成功");
                                        $(".vendor_instant[object_id='" + vendor.Id + "']").html($.renderVendor(vendor).html())
                                    });
                                },
                                error: function () {
                                    $.miniErrorAjaxResult("修改失败");
                                    $.enableButtons($("#vendor_edit_panel .buttons"));
                                }
                            });
                        });
                    })
                </script>
                <h3 class="caption">修改供应商信息</h3>
                <a class="close">x</a>
                <div class="pages">
                    <div class="line">
                        <label>公司名<span class="tip">*</span></label>
                        <input name="Title" readonly="readonly" />
                    </div>
                    <div class="line">
                        <label>Logo</label>
                        <input type="url" name="Logo" />
                    </div>
                    <div class="line">
                        <label>公司主页</label>
                        <input type="url" name="HomePage" />
                    </div>
                    <div class="line">
                        <label>办公电话</label>
                        <input type="phone" name="Phone" />
                    </div>
                    <div class="line">
                        <label>400电话</label>
                        <input type="phone" name="Phone_400" />
                    </div>
                    <div class="line">
                        <label>800电话</label>
                        <input type="phone" name="Phone_800" />
                    </div>
                    <div class="line">
                        <label>传真</label>
                        <input type="phone" name="Fax" />
                    </div>
                    <div class="line">
                        <label>邮箱</label>
                        <input type="phone" name="Email" />
                    </div>
                    <div class="line">
                        <label>公司地址</label>
                        <input name="Address" />
                    </div>
                    <div class="line">
                        <label>公司简介</label>
                        <textarea name="Description"></textarea>
                    </div>
                </div>
                <div class="bottom right">
                    <div class="buttons one_click_buttons">
                        <input type="submit" value="提交" />
                    </div>
                </div>
            </div>

            <div id="vendor_delete_panel" class="module popup">
                <script type="text/javascript">
                    $(function () {
                        $("#vendor_delete_panel input:submit").click(function () {
                            var objectId = $("#vendor_delete_panel").attr("object_id");

                            $.ajax({
                                type: $("#vendor_delete_panel").attr("method"),
                                url: $("#vendor_delete_panel").attr("api"),
                                dataType: "json",
                                success: function () {
                                    $.fadePopup($("#vendor_delete_panel"), function () {
                                        $.miniSuccessAjaxResult("删除成功");

                                        $.enableButtons($("#vendor_delete_panel .buttons"));
                                        $(".vendor_instant[object_id='" + objectId + "']").fadeOut("normal", function () {
                                            $(this).remove();
                                        })
                                    });
                                },
                                error: function () {
                                    $.miniErrorAjaxResult("删除失败");
                                    $.enableButtons($("#vendor_delete_panel .buttons"));
                                }
                            })
                        })
                    })
                </script>
                <h3 class="caption">删除</h3>
                <a class="close">x</a>
                <div class="pages">
                    <p class="gray center">加载中...</p>
                </div>
                <div class="bottom buttons one_click_buttons right">
                    <input type="submit" value="确认" />
                </div>
            </div>
        </div>

        <div id="category_panels">
            <script type="text/javascript">
                $(function () {
                    $(".taction[object='Category'][taction_type='1']").live("click", function () {
                        $("#category_create_panel").attr("method", $(this).attr("method")).attr("api", $(this).attr("api"));
                        $("#category_create_panel .caption").text($(this).attr("title"));

                        $.centerPopup($("#category_create_panel"));
                    });

                    $(".taction[object='Category'][taction_type='2']").live("click", function () {
                        window.open(PanelApiRoot + "Category/Details/" + $(this).attr("object_id"));
                    });

                    $(".taction[object='Category'][taction_type='3']").live("click", function () {
                        $("#category_edit_panel").attr("method", $(this).attr("method")).attr("api", $(this).attr("api"));
                        $("#category_edit_panel .caption").text($(this).attr("title"));

                        var objectId = $(this).attr("object_id");

                        $.ajax({
                            type: "GET",
                            url: PanelApiRoot + "Api/Category/" + objectId,
                            dataType: "json",
                            success: function (data) {
                                var category = data.Entity;

                                $("#category_edit_panel input[name='Title']").val(category.Title);
                                $("#category_edit_panel input[name='Abbreviation']").val(category.Abbreviation);
                                $("#category_edit_panel input[name='ChineseTitle']").val(category.ChineseTitle);
                                $("#category_edit_panel textarea[name='Description']").val(category.Description);

                                $.centerPopup($("#category_edit_panel"));
                            },
                            error: function () {
                                $.miniErrorAjaxResult("HIT产品类别 #" + objectId + " 不存在");
                            }
                        });
                    });

                    $(".taction[object='Category'][taction_type='4']").live("click", function () {
                        var objectId = $(this).attr("object_id");
                        $("#category_delete_panel").attr("method", $(this).attr("method")).attr("api", $(this).attr("api")).attr("object_id", objectId);
                        $("#category_delete_panel .caption").text($(this).attr("title"));

                        $("#category_delete_panel .pages").html("删除 #" + objectId + " HIT产品类别 吗?");
                        $.centerPopup($("#category_delete_panel"));
                    })

                    $(".taction[object='Category'][taction_type='5']").live("click", function () {
                        window.open(PanelApiRoot + "/Category/Search?Api=" + encodeUri($(this).attr("api")));
                    })
                })
            </script>

            <div id="category_create_panel" class="module popup">
                <script type="text/javascript">
                    $(function () {
                        $("#category_create_panel input:submit").click(function () {
                            var method = $("#category_create_panel").attr("method");
                            var api = $("#category_create_panel").attr("api");
                            $.ajax({
                                type: method,
                                url: api,
                                data: { 
                                    Title: $("#category_create_panel input[name='Title']").val(), 
                                    Abbreviation: $("#category_create_panel input[name='Abbreviation']").val(),
                                    ChineseTitle: $("#category_create_panel input[name='ChineseTitle']").val(),
                                    Description: $("#category_create_panel textarea[name='Description']").val(),       
                                },
                                dataType: "json",
                                success: function (data) {
                                    var category = data.Entity;
                                    
                                    $("#category_create_panel .pages input").val("");
                                    $("#category_create_panel .pages textarea").val("");

                                    $.enableButtons($("#category_create_panel .buttons"));

                                    $.fadePopup($("#category_create_panel"), function () {
                                        $.miniSuccessAjaxResult("发布成功");
                                        $("#categories .container").prepend($.renderCategory(category));
                                    });
                                },
                                error: function () {
                                    $.miniErrorAjaxResult("发布失败");

                                    $.enableButtons($("#category_create_panel .buttons"));
                                }
                            });
                        });
                    })
                </script>
                <h3 class="caption">创建HIT产品类别</h3>
                <a class="close">x</a>
                <div class="pages">
                    <div class="line">
                        <label>英文全称<span class="tip">*</span></label>
                        <input name="Title" />
                    </div>
                    <div class="line">
                        <label>英文缩写</label>
                        <input name="Abbreviation" />
                    </div>
                    <div class="line">
                        <label>中文名称</label>
                        <input name="ChineseTitle" />
                    </div>
                    <div class="line">
                        <label>简介</label>
                        <textarea name="Description"></textarea>
                    </div>
                </div>
                <div class="bottom right">
                    <div class="buttons one_click_buttons">
                        <input type="submit" value="提交" />
                    </div>
                </div>
            </div>

            <div id="category_edit_panel" class="module popup">
                <script type="text/javascript">
                    $(function () {
                        $("#category_edit_panel input:submit").click(function () {
                            var method = $("#category_edit_panel").attr("method");
                            var api = $("#category_edit_panel").attr("api");
                            $.ajax({
                                type: method,
                                url: api,
                                data: { 
                                    Abbreviation: $("#category_edit_panel input[name='Abbreviation']").val(),
                                    ChineseTitle: $("#category_edit_panel input[name='ChineseTitle']").val(),
                                    Description: $("#category_edit_panel textarea[name='Description']").val(),       
                                },
                                dataType: "json",
                                success: function (data) {
                                    var category = data.Entity;
                                    
                                    $("#category_edit_panel .pages input").val("");
                                    $("#category_edit_panel .pages textarea").val("");

                                    $.enableButtons($("#category_edit_panel .buttons"));

                                    $.fadePopup($("#category_edit_panel"), function () {
                                        $.miniSuccessAjaxResult("修改成功");
                                        $(".category_instant[object_id='" + category.Id + "']").html($.renderCategory(category).html());
                                    });
                                },
                                error: function () {
                                    $.miniErrorAjaxResult("修改失败");

                                    $.enableButtons($("#category_edit_panel .buttons"));
                                }
                            });
                        });
                    })
                </script>
                <h3 class="caption">修改HIT产品类别</h3>
                <a class="close">x</a>
                <div class="pages">
                    <div class="line">
                        <label>英文全称<span class="tip">*</span></label>
                        <input name="Title" readonly="readonly" />
                    </div>
                    <div class="line">
                        <label>英文缩写</label>
                        <input name="Abbreviation" />
                    </div>
                    <div class="line">
                        <label>中文名称</label>
                        <input name="ChineseTitle" />
                    </div>
                    <div class="line">
                        <label>简介</label>
                        <textarea name="Description"></textarea>
                    </div>
                </div>
                <div class="bottom right">
                    <div class="buttons one_click_buttons">
                        <input type="submit" value="提交" />
                    </div>
                </div>
            </div>

            <div id="category_delete_panel" class="module popup">
                <script type="text/javascript">
                    $(function () {
                        $("#category_delete_panel input:submit").click(function () {
                            var objectId = $("#category_delete_panel").attr("object_id");

                            $.ajax({
                                type: $("#category_delete_panel").attr("method"),
                                url: $("#category_delete_panel").attr("api"),
                                dataType: "json",
                                success: function () {
                                    $.fadePopup($("#category_delete_panel"), function () {
                                        $.miniSuccessAjaxResult("删除成功");

                                        $.enableButtons($("#category_delete_panel .buttons"));
                                        $(".category_instant[object_id='" + objectId + "']").fadeOut("normal", function () {
                                            $(this).remove();
                                        })
                                    });
                                },
                                error: function () {
                                    $.miniErrorAjaxResult("删除失败");
                                    $.enableButtons($("#category_delete_panel .buttons"));
                                }
                            })
                        })
                    })
                </script>
                <h3 class="caption">删除</h3>
                <a class="close">x</a>
                <div class="pages">
                    <p class="gray center">加载中...</p>
                </div>
                <div class="bottom buttons one_click_buttons right">
                    <input type="submit" value="确认" />
                </div>
            </div>
        </div>

        <script type="text/javascript">
            $.ajaxResult = function (caption, content, buttons) {
                $("#ajax_result .caption").html(caption);
                $("#ajax_result .pages").html(content);
                $("#ajax_result .bottom").html(buttons);
                $.centerPopup($("#ajax_result"));
            }
        </script>
        <div id="ajax_result" class="module popup">
            <h3 class="caption">ajax结果</h3>
            <a class="close">x</a>
            <div class="pages">
                <p class="gray center">加载中...</p>
            </div>
            <div class="bottom buttons right">
            </div>
        </div>

        <script type="text/javascript">
            $.miniSuccessAjaxResult = function (content) {
                $("#mini_success_ajax_result .pages").html(content);
                $.centerFlashPopup($("#mini_success_ajax_result"));
            }
        </script>
        <div id="mini_success_ajax_result" class="module popup flash">
            <div class="pages center" style="background: #3c6;color:#fff">
                <p class="gray center">加载中...</p>
            </div>
        </div>

        <script type="text/javascript">
            $.miniErrorAjaxResult = function (content) {
                $("#mini_error_ajax_result .pages").html(content);
                $.centerFlashPopup($("#mini_error_ajax_result"));
            }
        </script>
        <div id="mini_error_ajax_result" class="module popup flash">
            <div class="pages center" style="background: #f66;color:#fff">
                <p class="gray center">加载中...</p>
            </div>
        </div>

        <div id="popup_cover"></div>

        <div id="tools">
            <script type="text/javascript">
                $(function () {
                    $("#go_top").click(function () {
                        $('body').animate({ scrollTop: 0 }, "normal");
                        return false;
                    });
                })
            </script>
            <a id="go_top">返回<br />顶部</a>
        </div>