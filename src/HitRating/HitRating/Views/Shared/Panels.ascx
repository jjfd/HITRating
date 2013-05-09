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
                        window.location.href = (PanelApiRoot + "Vendor/Details/" + $(this).attr("object_id"));
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
                        window.location.href = (PanelApiRoot + "Vendor/Search?Api=" + encodeUri($(this).attr("api")));
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
                        window.location.href = (PanelApiRoot + "Category/Details/" + $(this).attr("object_id"));
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
                        window.location.href = (PanelApiRoot + "Category/Search?Api=" + encodeUri($(this).attr("api")));
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

        <div id="product_panels">
            <script type="text/javascript">
                $(function () {
                    $(".taction[object='Product'][taction_type='1']").live("click", function () {
                        $("#product_create_panel").attr("method", $(this).attr("method")).attr("api", $(this).attr("api"));
                        $("#product_create_panel .caption").text($(this).attr("title"));

                        $.centerPopup($("#product_create_panel"));
                    });

                    $(".taction[object='Product'][taction_type='2']").live("click", function () {
                        window.location.href = (PanelApiRoot + "Product/Details/" + $(this).attr("object_id"));
                    });

                    $(".taction[object='Product'][taction_type='3']").live("click", function () {
                        $("#product_edit_panel").attr("method", $(this).attr("method")).attr("api", $(this).attr("api"));
                        $("#product_edit_panel .caption").text($(this).attr("title"));

                        var objectId = $(this).attr("object_id");

                        $.ajax({
                            type: "GET",
                            url: PanelApiRoot + "Api/Product/" + objectId,
                            dataType: "json",
                            success: function (data) {
                                var product = data.Entity;

                                $("#product_edit_panel input[name='VendorId']").val(product.Vendor.Id);
                                $("#product_edit_panel input[name='VendorId']").siblings(".ajax_input_title").val(product.Vendor.Title);
                                $("#product_edit_panel input[name='Title']").val(product.Title);
                                $("#product_edit_panel input[name='Version']").val(product.Version);
                                $("#product_edit_panel input[name='Logo']").val(product.Logo);
                                if (product.Category != null) {
                                    $("#product_edit_panel input[name='CategoryId']").val(product.Category.Id);
                                    $("#product_edit_panel input[name='CategoryId']").siblings(".ajax_input_title").val(product.Category.Title);
                                }
                                $("#product_edit_panel input[name='Published']").val(product.Published);
                                $("#product_edit_panel input[name='PreVersion']").val(product.PreVersion);
                                $("#product_edit_panel input[name='PhonePreSale']").val(product.PhonePreSale);
                                $("#product_edit_panel input[name='PhoneAfterSale']").val(product.PhoneAfterSale);
                                $("#product_edit_panel textarea[name='Description']").val(product.Description);

                                $.centerPopup($("#product_edit_panel"));
                            },
                            error: function () {
                                $.miniErrorAjaxResult("HIT产品信息 #" + objectId + " 不存在");
                            }
                        });
                    });

                    $(".taction[object='Product'][taction_type='4']").live("click", function () {
                        var objectId = $(this).attr("object_id");
                        $("#product_delete_panel").attr("method", $(this).attr("method")).attr("api", $(this).attr("api")).attr("object_id", objectId);
                        $("#product_delete_panel .caption").text($(this).attr("title"));

                        $("#product_delete_panel .pages").html("删除 #" + objectId + " HIT产品信息吗?");
                        $.centerPopup($("#product_delete_panel"));
                    })

                    $(".taction[object='Product'][taction_type='5']").live("click", function () {
                        window.location.href = (PanelApiRoot + "Product/Search?Api=" + encodeUri($(this).attr("api")));
                    })
                })
            </script>

            <div id="product_create_panel" class="module popup">
                <script type="text/javascript">
                    $(function () {
                        $("#product_create_panel input:submit").click(function () {
                            var method = $("#product_create_panel").attr("method");
                            var api = $("#product_create_panel").attr("api");
                            $.ajax({
                                type: method,
                                url: api,
                                data: { 
                                    VendorId: $("#product_create_panel input[name='VendorId']").val(),
                                    Title: $("#product_create_panel input[name='Title']").val(),  
                                    Version: $("#product_create_panel input[name='Version']").val(), 
                                    Logo: $("#product_create_panel input[name='Logo']").val(),
                                    CategoryId: $("#product_create_panel input[name='CategoryId']").val(),
                                    Published: $("#product_create_panel input[name='Published']").val(),
                                    PreVersion: $("#product_create_panel input[name='PreVersion']").val(),
                                    PhonePreSale: $("#product_create_panel input[name='PhonePreSale']").val(),
                                    PhoneAfterSale: $("#product_create_panel input[name='PhoneAfterSale']").val(),  
                                    Description: $("#product_create_panel textarea[name='Description']").val(),       
                                },
                                dataType: "json",
                                success: function (data) {
                                    var product = data.Entity;
                                    
                                    $("#product_create_panel .pages input").val("");
                                    $("#product_create_panel .pages textarea").val("");

                                    $.enableButtons($("#product_create_panel .buttons"));

                                    $.fadePopup($("#product_create_panel"), function () {
                                        $.miniSuccessAjaxResult("发布成功");
                                        $("#products .container").prepend($.renderProduct(product));
                                    });
                                },
                                error: function () {
                                    $.miniErrorAjaxResult("发布失败");

                                    $.enableButtons($("#product_create_panel .buttons"));
                                }
                            });
                        });
                    })
                </script>
                <h3 class="caption">创建HIT产品信息</h3>
                <a class="close">x</a>
                <div class="pages">
                    <div class="line ajax_search" url="/Api/MiniVendors?Title=">
                        <label>供应商<span class="tip">*</span></label>
                        <input type="hidden" class="ajax_input_sid" name="VendorId">
                        <input class="ajax_input_title">
                        <div class="ajax_suggestions"></div>
                    </div>
                    <div class="line">
                        <label>产品名称<span class="tip">*</span></label>
                        <input name="Title" />
                    </div>
                    <div class="line">
                        <label>版本号<span class="tip">*</span></label>
                        <input type="version" name="Version" />
                    </div>
                    <div class="line">
                        <label>Logo</label>
                        <input type="url" name="Logo" />
                    </div>
                    <div class="line ajax_search" url="/Api/MiniCategories?Title=">
                        <label>产品类别</label>
                        <input type="hidden" class="ajax_input_sid" name="CategoryId">
                        <input class="ajax_input_title">
                        <div class="ajax_suggestions"></div>
                    </div>
                    <div class="line">
                        <label>发布日期</label>
                        <input type="date" name="Published" />
                    </div>
                    <div class="line">
                        <label>前一版本号</label>
                        <input type="version" name="PreVersion" />
                    </div>
                    <div class="line">
                        <label>售前电话</label>
                        <input type="phone" name="PhonePreSale" />
                    </div>
                    <div class="line">
                        <label>售后电话</label>
                        <input type="phone" name="PhoneAfterSale" />
                    </div>
                    <div class="line">
                        <label>产品简介</label>
                        <textarea name="Description"></textarea>
                    </div>
                </div>
                <div class="bottom right">
                    <div class="buttons one_click_buttons">
                        <input type="submit" value="提交" />
                    </div>
                </div>
            </div>

            <div id="product_edit_panel" class="module popup">
                <script type="text/javascript">
                    $(function () {
                        $("#product_edit_panel input:submit").click(function () {
                            var method = $("#product_edit_panel").attr("method");
                            var api = $("#product_edit_panel").attr("api");
                            $.ajax({
                                type: method,
                                url: api,
                                data: { 
                                    Logo: $("#product_edit_panel input[name='Logo']").val(),
                                    CategoryId: $("#product_edit_panel input[name='CategoryId']").val(),
                                    Published: $("#product_edit_panel input[name='Published']").val(),
                                    PreVersion: $("#product_edit_panel input[name='PreVersion']").val(),
                                    PhonePreSale: $("#product_edit_panel input[name='PhonePreSale']").val(),
                                    PhoneAfterSale: $("#product_edit_panel input[name='PhoneAfterSale']").val(),  
                                    Description: $("#product_edit_panel textarea[name='Description']").val(),       
                                },
                                dataType: "json",
                                success: function (data) {
                                    var product = data.Entity;
                                    
                                    $("#product_edit_panel .pages input").val("");
                                    $("#product_edit_panel .pages textarea").val("");

                                    $.enableButtons($("#product_edit_panel .buttons"));

                                    $.fadePopup($("#product_edit_panel"), function () {
                                        $.miniSuccessAjaxResult("修改成功");
                                        $(".product_instant[object_id='" + product.Id + "']").html($.renderProduct(product).html());
                                    });
                                },
                                error: function () {
                                    $.miniErrorAjaxResult("修改失败");

                                    $.enableButtons($("#product_edit_panel .buttons"));
                                }
                            });
                        });
                    })
                </script>
                <h3 class="caption">修改HIT产品信息</h3>
                <a class="close">x</a>
                <div class="pages">
                    <div class="line ajax_search" url="/Api/MiniVendors?Title=">
                        <label>供应商<span class="tip">*</span></label>
                        <input type="hidden" class="ajax_input_sid" name="VendorId">
                        <input class="ajax_input_title" readonly="readonly">
                        <div class="ajax_suggestions"></div>
                    </div>
                    <div class="line">
                        <label>产品名称<span class="tip">*</span></label>
                        <input name="Title" readonly="readonly" />
                    </div>
                    <div class="line">
                        <label>版本号<span class="tip">*</span></label>
                        <input type="version" name="Version" readonly="readonly" />
                    </div>
                    <div class="line">
                        <label>Logo</label>
                        <input type="url" name="Logo" />
                    </div>
                    <div class="line ajax_search" url="/Api/MiniCategories?Title=">
                        <label>产品类别</label>
                        <input type="hidden" class="ajax_input_sid" name="CategoryId">
                        <input class="ajax_input_title">
                        <div class="ajax_suggestions"></div>
                    </div>
                    <div class="line">
                        <label>发布日期</label>
                        <input type="date" name="Published" />
                    </div>
                    <div class="line">
                        <label>前一版本号</label>
                        <input type="version" name="PreVersion" />
                    </div>
                    <div class="line">
                        <label>售前电话</label>
                        <input type="phone" name="PhonePreSale" />
                    </div>
                    <div class="line">
                        <label>售后电话</label>
                        <input type="phone" name="PhoneAfterSale" />
                    </div>
                    <div class="line">
                        <label>产品简介</label>
                        <textarea name="Description"></textarea>
                    </div>
                </div>
                <div class="bottom right">
                    <div class="buttons one_click_buttons">
                        <input type="submit" value="提交" />
                    </div>
                </div>
            </div>

            <div id="product_delete_panel" class="module popup">
                <script type="text/javascript">
                    $(function () {
                        $("#product_delete_panel input:submit").click(function () {
                            var objectId = $("#product_delete_panel").attr("object_id");

                            $.ajax({
                                type: $("#product_delete_panel").attr("method"),
                                url: $("#product_delete_panel").attr("api"),
                                dataType: "json",
                                success: function () {
                                    $.fadePopup($("#product_delete_panel"), function () {
                                        $.miniSuccessAjaxResult("删除成功");

                                        $.enableButtons($("#product_delete_panel .buttons"));
                                        $(".product_instant[object_id='" + objectId + "']").fadeOut("normal", function () {
                                            $(this).remove();
                                        })
                                    });
                                },
                                error: function () {
                                    $.miniErrorAjaxResult("删除失败");
                                    $.enableButtons($("#product_delete_panel .buttons"));
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

        <div id="review_panels">
            <script type="text/javascript">
                $(function () {
                    $(".taction[object='Review'][taction_type='1']").live("click", function () {
                        $("#review_create_panel").attr("method", $(this).attr("method")).attr("api", $(this).attr("api"));
                        $("#review_create_panel .caption").text($(this).attr("title"));

                        var productId = $(this).attr("object_id");

                        $.ajax({
                            type: "GET",
                            url: PanelApiRoot + "Api/Product/" + productId,
                            dataType: "json",
                            success: function (data) {
                                var categoryId = data.Entity.Category.Id;
                                
                                $("#review_create_panel .review_aspects .add_aspect").attr("method", "post").attr("api", PanelApiRoot + "Api/Aspects?CategoryId=" + categoryId);
                                $("#review_create_panel .review_aspects .add_aspect .ajax_search").attr("url", PanelApiRoot + "Api/Category/" + categoryId + "/Aspects?Title=");

                                $("#review_create_panel .review_aspects .container").empty();

                                $.ajax({
                                    type: "GET",
                                    url: PanelApiRoot + "Api/Category/" + categoryId + "/Aspects",
                                    dataType: "json",
                                    success: function (data) {
                                        var aspects = data.Entities;

                                        for (var i = 0; i < aspects.length; i++) {
                                            $("#review_create_panel .review_aspects .container").append('<div class="line gray small rate_aspect_input" aspect_id="' + aspects[i].Id + '"><span class="float_right"><span class="star_input"><span class="stars"><span class="star">★</span><span class="star">★</span><span class="star">★</span><span class="star">★</span><span class="star">★</span></span><input type="hidden" class="Rate" /></span>&nbsp;[<a href="#remove_aspect" class="remove">去除</a>]</span><label class="Title">' + aspects[i].Title + '</label></div>');
                                        }

                                        $.centerPopup($("#review_create_panel"));
                                    },
                                    error: function () {
                                        $.centerPopup($("#review_create_panel"));
                                    }
                                })
                            },
                            error: function () {
                                $.centerPopup($("#review_create_panel"));
                            }
                        })
                    });

                    $(".taction[object='Review'][taction_type='2']").live("click", function () {
                        window.location.href = (PanelApiRoot + "Review/Details/" + $(this).attr("object_id"));
                    });

                    $(".taction[object='Review'][taction_type='3']").live("click", function () {
                        $("#review_edit_panel").attr("method", $(this).attr("method")).attr("api", $(this).attr("api"));
                        $("#review_edit_panel .caption").text($(this).attr("title"));

                        var objectId = $(this).attr("object_id");

                        $.ajax({
                            type: "GET",
                            url: PanelApiRoot + "Api/Review/" + objectId,
                            dataType: "json",
                            success: function (data) {
                                var review = data.Entity;

                                $("#review_edit_panel .star_input").find(".star").eq(review.Rate - 1).click();

                                $("#review_edit_panel textarea[name='Details']").val(review.Details);

                                $("#review_create_panel .review_aspects .add_aspect").attr("method", "post").attr("api", PanelApiRoot + "Api/Aspects?CategoryId=" + review.CategoryId);
                                $("#review_edit_panel .review_aspects .add_aspect .ajax_search").attr("url", PanelApiRoot + "Api/Category/" + review.CategoryId + "/Aspects?Title=");

                                $("#review_edit_panel .review_aspects .container").empty();
                                try {
                                    var aspects = review.RatedAspects;

                                    for (var i = 0; i < aspects.length; i++) {
                                        $("#review_edit_panel .review_aspects .container").append('<div class="line gray small rate_aspect_input" aspect_id="' + aspects[i].Id + '"><span class="float_right"><span class="star_input"><span class="stars"><span class="star">★</span><span class="star">★</span><span class="star">★</span><span class="star">★</span><span class="star">★</span></span><input type="hidden" class="Rate" /></span>&nbsp;[<a href="#remove_aspect" class="remove">去除</a>]</span><label class="Title">' + aspects[i].Title + '</label></div>');
                                    }

                                    for (var i = 0; i < aspects.length; i++) {
                                        $("#review_edit_panel .review_aspects .container .rate_aspect_input .star_input").eq(i).find(".star").eq(aspects[i].Rate - 1).click();
                                    }

                                    $.centerPopup($("#review_edit_panel"));

                                }
                                catch (e) {
                                    $.ajax({
                                        type: "GET",
                                        url: PanelApiRoot + "Api/Category/" + review.Category.Id + "/Aspects",
                                        dataType: "json",
                                        success: function (data) {
                                            var aspects = data.Entities;

                                            for (var i = 0; i < aspects.length; i++) {
                                                $("#review_edit_panel .review_aspects .container").append('<div class="line gray small rate_aspect_input" aspect_id="' + aspects[i].Id + '"><span class="float_right"><span class="star_input"><span class="stars"><span class="star">★</span><span class="star">★</span><span class="star">★</span><span class="star">★</span><span class="star">★</span></span><input type="hidden" class="Rate" /></span>&nbsp;[<a href="#remove_aspect" class="remove">去除</a>]</span><label class="Title">' + aspects[i].Title + '</label></div>');
                                            }

                                            $.centerPopup($("#review_edit_panel"));
                                        },
                                        error: function () {
                                            $.centerPopup($("#review_edit_panel"));
                                        }
                                    })
                                }
                            },
                            error: function () {
                                $.miniErrorAjaxResult("HIT产品评价 #" + objectId + " 不存在");
                            }
                        });
                    });

                    $(".taction[object='Review'][taction_type='4']").live("click", function () {
                        var objectId = $(this).attr("object_id");
                        $("#review_delete_panel").attr("method", $(this).attr("method")).attr("api", $(this).attr("api")).attr("object_id", objectId);
                        $("#review_delete_panel .caption").text($(this).attr("title"));

                        $("#review_delete_panel .pages").html("删除 #" + objectId + " HIT产品评价 吗?");
                        $.centerPopup($("#review_delete_panel"));
                    })

                    $(".taction[object='Review'][taction_type='5']").live("click", function () {
                        window.location.href = (PanelApiRoot + "Review/Search?Api=" + encodeUri($(this).attr("api")));
                    })

                    $(".rate_aspect_input .remove").live("click", function () {
                        var rateAspectInput = $(this).parents(".rate_aspect_input");
                        rateAspectInput.fadeOut("normal", function () {
                            rateAspectInput.remove();
                        })
                    })

                    $(".review_aspects .add_aspect .submit").live("click", function () {
                        var thisSubmit = $(this);

                        var newAspectTitle = $(this).parents(".add_aspect").find(".ajax_input_title").val();

                        if (newAspectTitle.length) {
                            var newAspectId = $(this).parents(".add_aspect").find(".ajax_input_sid").val();

                            if (newAspectId > 0) {
                                if ($(this).parents(".review_aspects").find(".container").find(".rate_aspect_input[aspect_id='" + newAspectId + "']").length) {
                                    $.miniErrorAjaxResult("已经存在.");
                                }
                                else {
                                    $(this).parents(".review_aspects").find(".container").append('<div class="line gray small rate_aspect_input" aspect_id="' + newAspectId + '"><span class="float_right"><span class="star_input"><span class="stars"><span class="star">★</span><span class="star">★</span><span class="star">★</span><span class="star">★</span><span class="star">★</span></span><input type="hidden" class="Rate" /></span>&nbsp;[<a href="#remove_aspect" class="remove">去除</a>]</span><label class="Title">' + newAspectTitle + '</label></div>');

                                    var stars = $(this).parents(".add_aspect").find("input[name='Rate']").val();
                                    if (stars > 0 && stars < 6) {
                                        $(this).parents(".review_aspects").find(".container").find(".rate_aspect_input").last().find(".star").eq(stars - 1).click();
                                    }

                                    $(this).parents(".add_aspect").find("input").val("");
                                    $(this).parents(".add_aspect").find(".star").removeClass("selected");
                                }
                            }
                            else {
                                var api = $(this).parents(".add_aspect").attr("api");

                                $.ajax({
                                    type: "POST",
                                    url: api,
                                    data: { Title: newAspectTitle },
                                    dataType: "json",
                                    success: function (data) {
                                        $(thisSubmit).parents(".review_aspects").find(".container").append('<div class="line gray small rate_aspect_input" aspect_id="' + data.Entity.Id + '"><span class="float_right"><span class="star_input"><span class="stars"><span class="star">★</span><span class="star">★</span><span class="star">★</span><span class="star">★</span><span class="star">★</span></span><input type="hidden" class="Rate" /></span>&nbsp;[<a href="#remove_aspect" class="remove">去除</a>]</span><label class="Title">' + data.Entity.Title + '</label></div>');

                                        $(thisSubmit).parents(".add_aspect").find(".input").val("");
                                        $(thisSubmit).parents(".add_aspect").find(".star").removeClass("selected");

                                        var stars = $(thisSubmit).parents(".add_aspect").find("input[name='Rate']").val();
                                        if (stars > 0 && stars < 6) {
                                            $(thisSubmit).parents(".review_aspects").find(".container").find(".rate_aspect_input").last().find(".star").eq(stars - 1).click();
                                        }

                                        $(thisSubmit).parents(".add_aspect").find("input").val("");
                                        $(thisSubmit).parents(".add_aspect").find(".star").removeClass("selected");
                                    },
                                    error: function () {
                                        $.miniErrorAjaxResult("添加Aspect失败.");
                                    }
                                })
                            }
                        }
                    })
                })
            </script>

            <div id="review_create_panel" class="module popup">
                <script type="text/javascript">
                    $(function () {
                        $("#review_create_panel input:submit").click(function () {
                            var method = $("#review_create_panel").attr("method");
                            var api = $("#review_create_panel").attr("api");

                            var ratedAspects = $("#review_create_panel .review_aspects .container .rate_aspect_input");
                            var ratedAspectsString = "";

                            for (var i=0; i<ratedAspects.length; i++) {
                                var aspect = ratedAspects.eq(i)
                                var rate = aspect.find(".Rate").val();

                                if (rate > 0 && rate < 6) {
                                    aspectId = aspect.attr("aspect_id");
                                    aspectTitle = aspect.find(".Title").text();

                                    ratedAspectsString += aspectId + "|" + aspectTitle + "|" + rate + ";";
                                }
                            }
                            $.ajax({
                                type: method,
                                url: api,
                                data: { 
                                    Rate: $("#review_create_panel input[name='Rate']").val(),
                                    Details: $("#review_create_panel textarea[name='Details']").val(),
                                    RatedAspects: ratedAspectsString
                                },
                                dataType: "json",
                                success: function (data) {
                                    var review = data.Entity;
                                    
                                    $("#category_create_panel .pages input").val("");
                                    $("#category_create_panel .pages .star_input .star").removeClass("selected");
                                    $("#category_create_panel .pages textarea").val("");

                                    $.enableButtons($("#review_create_panel .buttons"));

                                    $.fadePopup($("#review_create_panel"), function () {
                                        $.miniSuccessAjaxResult("发布成功");
                                        $("#reviews .container").prepend($.renderReview(review));
                                    });
                                },
                                error: function () {
                                    $.miniErrorAjaxResult("发布失败");

                                    $.enableButtons($("#review_create_panel .buttons"));
                                }
                            });
                        });
                    })
                </script>
                <h3 class="caption">创建产品评价</h3>
                <a class="close">x</a>
                <div class="pages">
                    <div class="line">
                        <label>整体评分<span class="tip">*</span></label>
                        <span class="star_input">
                            <span class="stars">
                                <span class="star">★</span>
                                <span class="star">★</span>
                                <span class="star">★</span>
                                <span class="star">★</span>
                                <span class="star">★</span>
                            </span>
                            <input type="hidden" name="Rate" />
                        </span>
                    </div>
                    <div class="review_aspects">
                        <div class="toggle_read">
                            <p class="right"><a class="toggle">详细评分</a></p>
                            <div class="toggle_content"></div>
                            <div class="toggle_content hidden">
                                <div class="container">
                                    
                                </div>
                                <div class="add_aspect small">
                                    <div class="line ajax_search" url="">
                                        <span class="float_right">
                                            <span class="star_input">
                                                <span class="stars">
                                                    <span class="star">★</span><span class="star">★</span><span class="star">★</span><span class="star">★</span><span class="star">★</span>
                                                </span>
                                                <input type="hidden" name="Rate" />
                                            </span>
                                            [<a href="#add_aspect" class="submit">添加</a>]
                                        </span>
                                        <input type="hidden" class="ajax_input_sid" value="">
                                        <input class="ajax_input_title tip_search" value="添加更多的评价方面的问题" style="width:70%">
                                        <div class="ajax_suggestions"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="line">
                        <label>详细评论<span class="tip">*</span></label>
                        <textarea name="Details"></textarea>
                    </div>
                </div>
                <div class="bottom right">
                    <div class="buttons one_click_buttons">
                        <input type="submit" value="提交" />
                    </div>
                </div>
            </div>

            <div id="review_edit_panel" class="module popup">
                <script type="text/javascript">
                    $(function () {
                        $("#review_edit_panel input:submit").click(function () {
                            var method = $("#review_edit_panel").attr("method");
                            var api = $("#review_edit_panel").attr("api");

                            var ratedAspects = $("#review_edit_panel .review_aspects .container .rate_aspect_input");
                            var ratedAspectsString = "";

                            for (var i = 0; i < ratedAspects.length; i++) {
                                var aspect = ratedAspects.eq(i)
                                var rate = aspect.find(".Rate").val();

                                if (rate > 0 && rate < 6) {
                                    aspectId = aspect.attr("aspect_id");
                                    aspectTitle = aspect.find(".Title").text();

                                    ratedAspectsString += aspectId + "|" + aspectTitle + "|" + rate + ";";
                                }
                            }
                            $.ajax({
                                type: method,
                                url: api,
                                data: {
                                    Rate: $("#review_edit_panel input[name='Rate']").val(),
                                    Details: $("#review_edit_panel textarea[name='Details']").val(),
                                    RatedAspects: ratedAspectsString
                                },
                                dataType: "json",
                                success: function (data) {
                                    var review = data.Entity;
                                    
                                    $("#review_edit_panel .pages input").val("");
                                    $("#review_edit_panel .pages .star_input .star").removeClass("selected");
                                    $("#review_edit_panel .pages textarea").val("");

                                    $.enableButtons($("#review_edit_panel .buttons"));

                                    $.fadePopup($("#review_edit_panel"), function () {
                                        $.miniSuccessAjaxResult("修改成功");
                                        $(".review_instant[object_id='" + review.Id + "']").html($.renderReview(review).html());
                                    });
                                },
                                error: function () {
                                    $.miniErrorAjaxResult("修改失败");

                                    $.enableButtons($("#review_edit_panel .buttons"));
                                }
                            });
                        });
                    })
                </script>
                <h3 class="caption">修改产品评价</h3>
                <a class="close">x</a>
                <div class="pages">
                    <div class="line">
                        <label>整体评分<span class="tip">*</span></label>
                        <span class="star_input">
                            <span class="stars">
                                <span class="star">★</span>
                                <span class="star">★</span>
                                <span class="star">★</span>
                                <span class="star">★</span>
                                <span class="star">★</span>
                            </span>
                            <input type="hidden" name="Rate" />
                        </span>
                    </div>
                    <div class="review_aspects">
                        <div class="toggle_read">
                            <p class="right"><a class="toggle">详细评分</a></p>
                            <div class="toggle_content hidden"></div>
                            <div class="toggle_content">
                                <div class="container">
                                    
                                </div>
                                <div class="add_aspect small">
                                    <div class="line ajax_search" url="">
                                        <span class="float_right">
                                            <span class="star_input">
                                                <span class="stars">
                                                    <span class="star">★</span><span class="star">★</span><span class="star">★</span><span class="star">★</span><span class="star">★</span>
                                                </span>
                                                <input type="hidden" name="Rate" />
                                            </span>
                                            [<a href="#add_aspect" class="submit">添加</a>]
                                        </span>
                                        <input type="hidden" class="ajax_input_sid" value="">
                                        <input class="ajax_input_title tip_search" value="添加更多的评价方面的问题" style="width:70%">
                                        <div class="ajax_suggestions"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="line">
                        <label>详细评价<span class="tip">*</span></label>
                        <textarea name="Details"></textarea>
                    </div>
                </div>
                <div class="bottom right">
                    <div class="buttons one_click_buttons">
                        <input type="submit" value="提交" />
                    </div>
                </div>
            </div>

            <div id="review_delete_panel" class="module popup">
                <script type="text/javascript">
                    $(function () {
                        $("#review_delete_panel input:submit").click(function () {
                            var objectId = $("#review_delete_panel").attr("object_id");

                            $.ajax({
                                type: $("#review_delete_panel").attr("method"),
                                url: $("#review_delete_panel").attr("api"),
                                dataType: "json",
                                success: function () {
                                    $.fadePopup($("#review_delete_panel"), function () {
                                        $.miniSuccessAjaxResult("删除成功");

                                        $.enableButtons($("#review_delete_panel .buttons"));
                                        $(".review_instant[object_id='" + objectId + "']").fadeOut("normal", function () {
                                            $(this).remove();
                                        })
                                    });
                                },
                                error: function () {
                                    $.miniErrorAjaxResult("删除失败");
                                    $.enableButtons($("#review_delete_panel .buttons"));
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

        <div id="comment_panels">
            <script type="text/javascript">
                $(function () {
                    $(".taction[object='Comment'][taction_type='1']").live("click", function () {
                        $("#comment_create_panel").attr("method", $(this).attr("method")).attr("api", $(this).attr("api"));
                        $("#comment_create_panel .caption").text($(this).attr("title"));

                        $.centerPopup($("#comment_create_panel"));
                    });

                    $(".taction[object='Comment'][taction_type='2']").live("click", function () {
                        //window.location.href = (PanelApiRoot + "Comment/Details/" + $(this).attr("object_id"));
                        return false;
                    });

                    $(".taction[object='Comment'][taction_type='3']").live("click", function () {
                        $("#comment_edit_panel").attr("method", $(this).attr("method")).attr("api", $(this).attr("api"));
                        $("#comment_edit_panel .caption").text($(this).attr("title"));

                        var objectId = $(this).attr("object_id");

                        $.ajax({
                            type: "GET",
                            url: PanelApiRoot + "Api/Comment/" + objectId,
                            dataType: "json",
                            success: function (data) {
                                var comment = data.Entity;

                                $("#comment_edit_panel textarea[name='Details']").val(comment.Details);

                                $.centerPopup($("#comment_edit_panel"));
                            },
                            error: function () {
                                $.miniErrorAjaxResult("评论 #" + objectId + " 不存在");
                            }
                        });
                    });

                    $(".taction[object='Comment'][taction_type='4']").live("click", function () {
                        var objectId = $(this).attr("object_id");
                        $("#comment_delete_panel").attr("method", $(this).attr("method")).attr("api", $(this).attr("api")).attr("object_id", objectId);
                        $("#comment_delete_panel .caption").text($(this).attr("title"));

                        $("#comment_delete_panel .pages").html("删除 #" + objectId + " 评论 吗?");
                        $.centerPopup($("#comment_delete_panel"));
                    })

                    $(".taction[object='Comment'][taction_type='5']").live("click", function () {
                        window.location.href = (PanelApiRoot + "Comment/Search?Api=" + encodeUri($(this).attr("api")));
                    })

                })
            </script>

            <div id="comment_create_panel" class="module popup">
                <script type="text/javascript">
                    $(function () {
                        $("#comment_create_panel input:submit").click(function () {
                            var method = $("#comment_create_panel").attr("method");
                            var api = $("#comment_create_panel").attr("api");
                            $.ajax({
                                type: method,
                                url: api,
                                data: { 
                                    Details: $("#comment_create_panel textarea[name='Details']").val(),       
                                },
                                dataType: "json",
                                success: function (data) {
                                    var comment = data.Entity;
                                    
                                    $("#comment_create_panel .pages input").val("");
                                    $("#comment_create_panel .pages textarea").val("");

                                    $.enableButtons($("#comment_create_panel .buttons"));

                                    $.fadePopup($("#comment_create_panel"), function () {
                                        $.miniSuccessAjaxResult("发布成功");
                                        $("#comments .container").prepend($.renderComment(comment));
                                    });
                                },
                                error: function () {
                                    $.miniErrorAjaxResult("发布失败");

                                    $.enableButtons($("#comment_create_panel .buttons"));
                                }
                            });
                        });
                    })
                </script>
                <h3 class="caption">评论</h3>
                <a class="close">x</a>
                <div class="pages">
                    <div class="line">
                        <label>你的评论<span class="tip">*</span></label>
                        <textarea name="Details"></textarea>
                    </div>
                </div>
                <div class="bottom right">
                    <div class="buttons one_click_buttons">
                        <input type="submit" value="提交" />
                    </div>
                </div>
            </div>

            <div id="comment_edit_panel" class="module popup">
                <script type="text/javascript">
                    $(function () {
                        $("#comment_edit_panel input:submit").click(function () {
                            var method = $("#comment_edit_panel").attr("method");
                            var api = $("#comment_edit_panel").attr("api");
                            $.ajax({
                                type: method,
                                url: api,
                                data: { 
                                    Details: $("#comment_edit_panel textarea[name='Details']").val(),       
                                },
                                dataType: "json",
                                success: function (data) {
                                    var comment = data.Entity;
                                    
                                    $("#comment_edit_panel .pages input").val("");
                                    $("#comment_edit_panel .pages textarea").val("");

                                    $.enableButtons($("#comment_edit_panel .buttons"));

                                    $.fadePopup($("#comment_edit_panel"), function () {
                                        $.miniSuccessAjaxResult("修改成功");
                                        $(".comment_instant[object_id='" + comment.Id + "']").html($.renderComment(comment).html());
                                    });
                                },
                                error: function () {
                                    $.miniErrorAjaxResult("修改失败");

                                    $.enableButtons($("#comment_edit_panel .buttons"));
                                }
                            });
                        });
                    })
                </script>
                <h3 class="caption">修改评论</h3>
                <a class="close">x</a>
                <div class="pages">
                    <div class="line">
                        <label>你的评论<span class="tip">*</span></label>
                        <textarea name="Details"></textarea>
                    </div>
                </div>
                <div class="bottom right">
                    <div class="buttons one_click_buttons">
                        <input type="submit" value="提交" />
                    </div>
                </div>
            </div>

            <div id="comment_delete_panel" class="module popup">
                <script type="text/javascript">
                    $(function () {
                        $("#comment_delete_panel input:submit").click(function () {
                            var objectId = $("#comment_delete_panel").attr("object_id");

                            $.ajax({
                                type: $("#comment_delete_panel").attr("method"),
                                url: $("#comment_delete_panel").attr("api"),
                                dataType: "json",
                                success: function () {
                                    $.fadePopup($("#comment_delete_panel"), function () {
                                        $.miniSuccessAjaxResult("删除成功");

                                        $.enableButtons($("#comment_delete_panel .buttons"));
                                        $(".comment_instant[object_id='" + objectId + "']").fadeOut("normal", function () {
                                            $(this).remove();
                                        })
                                    });
                                },
                                error: function () {
                                    $.miniErrorAjaxResult("删除失败");
                                    $.enableButtons($("#comment_delete_panel .buttons"));
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

        <div id="vote_panels" class="hidden">
            <div id="vote_create_panel" class="module popup">
                <script type="text/javascript">
                    $(function () {
                        $(".taction[object='Vote'][taction_type='1']").live("click", function () {
                            var method = $(this).attr("method");
                            var api = $(this).attr("api");
                            var targetId = $(this).attr("object_id");
                            var voteMsg = $(this).parents(".vote_message");
                            $.ajax({
                                type: method,
                                url: api,
                                dataType: "json",
                                success: function (data) {
                                    var comment = data.Entity;

                                    $.miniSuccessAjaxResult("感谢你的投票");
                                    $(voteMsg).html("<span class='gray'>感谢你的投票!</span>");
                                },
                                error: function () {
                                    $.miniErrorAjaxResult("投票失败，或无法重复投票");
                                }
                            });
                        });
                    })
                </script>
                <h3 class="caption">评论</h3>
                <a class="close">x</a>
                <div class="pages">
                    <div class="line">
                        <label>你的评论<span class="tip">*</span></label>
                        <textarea name="Details"></textarea>
                    </div>
                </div>
                <div class="bottom right">
                    <div class="buttons one_click_buttons">
                        <input type="submit" value="提交" />
                    </div>
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