{{ define "css" }}
    <link href="/public/plug-in/dataTables/css/datatables.min.css" rel="stylesheet">
    <link href="/public/plug-in/awesome-bootstrap-checkbox/awesome-bootstrap-checkbox.css" rel="stylesheet">
    <style>
        .checkbox label::before{top:1px; left:1px;}
    </style>
{{ end }}

{{ define "content" }}
    {{/*breadcrumbs*/}}
    <div class="row wrapper border-bottom white-bg page-heading">
        <div class="col-lg-10">
            <h2>{{ .title}}</h2>
            <ol class="breadcrumb">
                <li class="breadcrumb-item">
                    <a href="/admin/dashboard"><i class="fal fa-desktop"></i> 系统面板</a>
                </li>
                <li class="breadcrumb-item">
                    <i class="fal fa-cogs"></i> 系统设置
                </li>
                <li class="breadcrumb-item active">
                    <strong><i class="fal fa-user-tie"></i> {{ .title}}</strong>
                </li>
            </ol>
        </div>
        <div class="col-lg-2">

        </div>
    </div>

    {{/*content*/}}
    <div class="wrapper wrapper-content animated fadeInRight">
        <p><a class="btn btn-primary" href="admin/create"> <i class="fal fa-plus-circle"></i> 创建管理员</a></p>
        <div class="row">
            <div class="col-lg-12">
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5>{{ .title}}</h5>
                        <div class="ibox-tools">
                            <a class="collapse-link">
                                <i class="fal fa-chevron-up"></i>
                            </a>
                            <a class="dropdown-toggle" data-toggle="dropdown" href="#">
                                <i class="fal fa-wrench"></i>
                            </a>
                            <ul class="dropdown-menu dropdown-admin">
                                <li><a href="#">选项 1</a></li>
                                <li><a href="#">选项 2</a></li>
                            </ul>
                            <a class="close-link">
                                <i class="fal fa-times"></i>
                            </a>
                        </div>
                    </div>
                    <div class="ibox-content">

                        <div class="table-responsive">
                            <table class="table table-striped table-bordered table-hover dataTables">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>姓名</th>
                                        <th>邮箱</th>
                                        <th>手机号码</th>
                                        <th>创建时间</th>
                                        <th>更新时间</th>
                                        <th>操作</th>
                                    </tr>
                                </thead>
                                <tfoot>
                                    <tr>
                                        <th>ID</th>
                                        <th>姓名</th>
                                        <th>邮箱</th>
                                        <th>手机号码</th>
                                        <th>创建时间</th>
                                        <th>更新时间</th>
                                        <th>操作</th>
                                    </tr>
                                </tfoot>
                            </table>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>


    <div class="modal inmodal" id="policy-modal" tabindex="-1" role="dialog" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content animated bounceInRight">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                    <i class="fal fa-user-cog modal-icon"></i>
                    <h4 class="modal-title">管理员授权</h4>
                    <small class="font-bold">你可以在角色权限中自定义你需要的角色</small>
                </div>
                <div class="modal-body">
                    <h3><i class="fal fa-cogs"></i> 系统角色</h3>
                    <div class="row">
                        {{ range $r := .roles}}
                            {{if Contains $r ":sys:" }}
                                <div class="col-lg-4">
                                    <div class="checkbox checkbox-primary">
                                        <input type="checkbox" class="role" name="roles[]" id="{{$r}}" value="{{$r}}" >
                                        <label for="{{$r}}" class="font-bold">
                                            {{ Replace (Replace (Replace $r "role:" "" 1) "sys:" "" 1) "ctr:" "" 1}}
                                        </label>
                                    </div>
                                </div>
                            {{ end }}
                        {{ end }}
                    </div>
                    <h3><i class="fal fa-user"></i> 控制器角色</h3>
                    <div class="row">
                        {{ range $r := .roles}}
                            {{if Contains $r ":ctr:" }}
                                <div class="col-lg-4">
                                    <div class="checkbox checkbox-primary">
                                        <input type="checkbox" class="role" name="roles[]" id="{{$r}}" value="{{$r}}" >
                                        <label for="{{$r}}" class="font-bold">
                                            {{ Replace (Replace (Replace $r "role:" "" 1) "sys:" "" 1) "ctr:" "" 1}}
                                        </label>
                                    </div>
                                </div>
                            {{ end }}
                        {{ end }}
                    </div>
                    <h3><i class="fal fa-user-cog"></i> 自定义角色</h3>
                    <div class="row">
                        {{ range $r := .roles}}
                            {{if or (Contains $r ":sys:") (Contains $r ":ctr:")}}

                            {{ else }}
                                <div class="col-lg-4">
                                    <div class="checkbox checkbox-primary">
                                        <input type="checkbox" class="role" name="roles[]" id="{{$r}}" value="{{$r}}" >
                                        <label for="{{$r}}" class="font-bold">
                                            {{ Replace (Replace (Replace $r "role:" "" 1) "sys:" "" 1) "ctr:" "" 1}}
                                        </label>
                                    </div>
                                </div>
                            {{ end }}
                        {{ end }}
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-white" data-dismiss="modal"><i class="fal fa-times"></i> 关闭</button>
                    <button type="button" class="btn btn-primary btn-save"><i class="fal fa-paper-plane"></i> 保存</button>
                </div>
            </div>
        </div>
    </div>

{{ end }}

{{ define "js" }}
    <!-- Custom and plugin javascript -->

    <script type="text/javascript" src="/public/plug-in/dataTables/js/datatables.min.js"></script>

    <script>
        $(document).ready(function() {
            $('.dataTables').DataTable({
                order: [[ 0, "desc" ]],
                autoWidth: false,
                language:{
                    url: '/public/plug-in/dataTables/Zh_cn.json',
                },
                pageLength: 25,
                responsive: true,
                processing: true,
                serverSide: true,
                ajax: {
                    url: "/admin/admin/data",
                    type: "GET"
                },
                columns: [
                    { "data": "base.id" },
                    { "data": "name" },
                    { "data": "email" },
                    { "data": "mobile" },
                    { "data": "created_at", "render":
                        function(data, type, row, meta){
                            return moment(row.base.created_at).format("YYYY-MM-DD HH:mm:ss");
                        }
                    },
                    { "data": "updated_at", "render":
                        function(data, type, row, meta){
                            return moment(row.base.updated_at).format("YYYY-MM-DD HH:mm:ss");
                        }
                    },
                    { "data": null, "render":
                        function(data, type, row, meta){
                            return '<a href="/admin/admin/show/'+row.base.id+'" class="btn btn-xs btn-outline btn-primary"><i class="fal fa-eye"></i> 查看</a> ' +
                                '<a href="/admin/admin/edit/'+row.base.id+'" class="btn btn-xs btn-outline btn-success"><i class="fal fa-edit"></i> 编辑</a> ' +
                                '<a href="javascript:void(0)" class="btn btn-xs btn-outline btn-warning policy '+(row.name=="admin"?"disabled":"")+'" data-toggle="modal" data-target="#policy-modal" data-url="/admin/admin/roles/'+row.base.id+'"><i class="fal fa-cogs"></i> 授权</a> ' +
                                '<a href="/admin/admin/delete/'+row.base.id+'" class="btn btn-xs btn-outline btn-danger"><i class="fal fa-trash-alt"></i> 删除</a>';
                        }
                    }
                ],
                dom: '<"html5buttons"B>lTfgitp'

            });
        });

        $("#page-wrapper").on("click",".policy",function(){
            let url = $(this).attr('data-url');
            $("#policy-modal").attr('data-url',url);
            $.get(url,function(result){
                if(result.roles.length > 0){
                    $.each(result.roles,function (i,item) {
                        $('input.role').each(function(j,input){
                            if($(input).val() == item){
                                $(input).prop('checked', true);
                            }
                        })
                    })
                }
            })
        });

        $("#policy-modal .btn-save").on("click",function(){
            let url = $("#policy-modal").attr('data-url');
            let params = {
                roles:[]
            };
            $('input.role').each(function(j,input){
                if($(input).prop('checked') == true){
                    params.roles.push($(input).val());
                }
            });
            $.post(url, params,function (result) {
                if(result.status == "success"){
                    $('#policy-modal').modal('hide');
                }
            })
        });

    </script>
{{ end }}