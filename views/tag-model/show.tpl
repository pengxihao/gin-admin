{{ define "css" }}
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
                    <strong><i class="fal fa-tags"></i> 标签管理</strong>
                </li>
            </ol>
        </div>
        <div class="col-lg-2">

        </div>
    </div>

    {{/*content*/}}
    <div class="wrapper wrapper-content animated fadeInRight">
        <div class="row">
            <div class="col-lg-6">
                <p>
                    <a class="btn btn-outline btn-success" href="/admin/tag/edit/{{ .tag.ID }}"><i class="fal fa-edit"></i> 更新</a>
                    <a class="btn btn-outline btn-danger" href="/admin/tag/delete/{{ .tag.ID }}"><i class="fal fa-trash-alt"></i> 删除</a>
                </p>
                <div class="ibox float-e-margins">
                    <div class="ibox-title">
                        <h5>{{ .title }}</h5>
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
                        <table id="w0" class="table table-striped table-bordered detail-view">
                            <tbody>
                                <tr>
                                    <th>标签管理编号</th><td>{{ .tagModel.ID }}</td>
                                </tr>
                                <tr>
                                    <th>模型</th><td>{{ .tagModel.Model }}</td>
                                </tr>
                                <tr>
                                    <th>模型编号</th><td>{{ .tagModel.ModelID }}</td>
                                </tr>
                                <tr>
                                    <th>标签</th><td>{{ .tagModel.Tag.Name }}</td>
                                </tr>
                                <tr>
                                    <th>创建时间</th><td>{{ .tagModel.CreatedAt.Format "2006-01-02 15:04:05" }}</td>
                                </tr>
                                <tr>
                                    <th>更新时间</th><td>{{ .tagModel.UpdatedAt.Format "2006-01-02 15:04:05" }}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
{{ end }}

{{ define "js" }}
{{ end }}