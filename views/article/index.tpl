{{ define "css" }}
    <link href="/public/plug-in/dataTables/css/datatables.min.css" rel="stylesheet">
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
                    <i class="fal fa-th-large"></i> 基础数据
                </li>
                <li class="breadcrumb-item active">
                    <strong><i class="fal fa-file-word"></i> {{ .title}}</strong>
                </li>
            </ol>
        </div>
        <div class="col-lg-2">

        </div>
    </div>

    {{/*content*/}}
    <div class="wrapper wrapper-content animated fadeInRight">
        <p><a class="btn btn-primary" href="article/create"> <i class="fal fa-plus-circle"></i> 创建文章</a></p>
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
                            <ul class="dropdown-menu dropdown-user">
                                <li><a href="#">选项 1</a></li>
                                <li><a href="#">选项 2</a></li>
                            </ul>
                            <a class="close-link">
                                <i class="fal fa-times"></i>
                            </a>
                        </div>
                    </div>
                    <div class="ibox-content">

                        <div class="table-responsive" data-image="{{.image}}">
                            <table class="table table-striped table-bordered table-hover dataTables">
                                <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>封面</th>
                                    <th>标题</th>
                                    <th>分类</th>
                                    <th>用户</th>
                                    <th>审核</th>
                                    <th>热门</th>
                                    <th>推荐</th>
                                    <th>点击量</th>
                                    <th>喜欢量</th>
                                    <th>评论量</th>
                                    <th>创建时间</th>
                                    <th>更新时间</th>
                                    <th>操作</th>
                                </tr>
                                </thead>
                                <tfoot>
                                <tr>
                                    <th>ID</th>
                                    <th>封面</th>
                                    <th>标题</th>
                                    <th>分类</th>
                                    <th>用户</th>
                                    <th>审核</th>
                                    <th>热门</th>
                                    <th>推荐</th>
                                    <th>点击量</th>
                                    <th>喜欢量</th>
                                    <th>评论量</th>
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
{{end}}

{{ define "js" }}
    <!-- Custom and plugin javascript -->
    <!-- https://datatables.net/download/index -->

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
                    url: "/admin/article/data",
                    type: "GET"
                },
                columns: [
                    { "data": "base.id" },
                    { "data": "cover", "render":
                        function(data, type, row, meta){
                            return row.cover > 0? '<img class="img-thumbnail" src="'+$(".table-responsive").data('image')+row.file.path+'" style="max-height:80px"/>':'';
                        }
                    },
                    { "data": "title" },
                    { "data": "article_category.name" },
                    { "data": "user.name" },
                    { "data": "audit", "class":"text-center", "render":
                        function(data, type, row, meta){
                            return row.audit == 1?'<span class="glyphicon glyphicon-ok text-success"></span>':'<span class="glyphicon glyphicon-remove text-danger"></span>';
                        }
                    },
                    { "data": "hot", "class":"text-center", "render":
                            function(data, type, row, meta){
                                return row.hot == 1?'<span class="glyphicon glyphicon-ok text-primary"></span>':'<span class="glyphicon glyphicon-remove text-danger"></span>';
                            }
                    },
                    { "data": "recommend", "class":"text-center", "render":
                            function(data, type, row, meta){
                                return row.recommend == 1?'<span class="glyphicon glyphicon-ok text-warning"></span>':'<span class="glyphicon glyphicon-remove text-danger"></span>';
                            }
                    },
                    { "data": "hit" },
                    { "data": "favorite" },
                    { "data": "comment" },
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
                    { "data": null, "render": function(data, type, row, meta){
                            return '<a href="/admin/article/show/'+row.base.id+'" class="btn btn-xs btn-outline btn-primary"><i class="fal fa-eye"></i> 查看</a> ' +
                            '<a href="/admin/article/edit/'+row.base.id+'" class="btn btn-xs btn-outline btn-success"><i class="fal fa-edit"></i> 编辑</a> ' +
                            '<a href="/admin/article/delete/'+row.base.id+'" class="btn btn-xs btn-outline btn-danger"><i class="fal fa-trash-alt"></i> 删除</a>';
                        }
                    }
                ],
                dom: '<"html5buttons"B>lTfgitp'

            });

        });

    </script>
{{ end }}