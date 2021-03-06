﻿<%@ Page Title="About Math Is Cool" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="MathIsCool.About" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <script type="text/javascript" src="ckeditor/ckeditor.js"></script>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script>
    <p>
        <input onclick="createEditor();" type="button" value="Edit Contents" />
        <input onclick="removeEditor();" type="button" value="Finish Editing" />
    </p>
    <!-- This div will hold the editor. -->
    <div id="editor">
    </div>
    <div id="contents" >

        <h2><p class="text-center"><%: Title %></p></h2>
        <p class="text-center" id="editorcontents"></p>
    </div>

    <script type="text/javascript">
        //create the AJAX PUT wrapper
        $.put = function (url, data, callback, type) {
            if ($.isFunction(data)) {
                type = type || callback,
                        callback = data,
                        data = {}
            }
            return $.ajax({
                url: url,
                type: 'PUT',
                success: callback,
                data: data,
                contentType: type
            });
        }

        var editor;
        var text;

        function createEditor() {
            $("#editor").show();
            //if the editor is already initialized, destroy it first
            if (editor) {
                return;
            }
            CKEDITOR.editorConfig = function (config) {
                config.autoParagraph = false;
                config.enterMode = CKEDITOR.ENTER_BR;
            };
            var html = document.getElementById('editorcontents').innerHTML;

            ;
            // Create a new editor inside the <div id="editor">, setting its value to html
            var config = {};
            if (text == null) {
                editor = CKEDITOR.appendTo('editor', config, html);
                console.log("text was null");
            }
            else {
                editor = CKEDITOR.appendTo('editor', config, text);
            }
        }

        function removeEditor() {
            if (!editor)
                return;

            // Retrieve the editor contents. In an Ajax application, this data would be
            // sent to the server or used in any other way.
         
            document.getElementById('editorcontents').innerHTML = editor.getData();
            document.getElementById('contents').style.display = '';
            data = {
                "type": "about",
                "description": editor.getData()
            };

            window.onload = function () {
                document.getElementById('editorcontents').outerHTML = editor.getData();
            }

            $.put("http://maxtowery.net/mic/api_static_pages.php", data, updateList, "json");
            editor.destroy();
            editor = null;

            text = null;
        }
        function updateList(dt) {
        }
        function gotList(dt) {
            text = dt[0]['description'];
            createEditor();

            document.getElementById('editorcontents').innerHTML = editor.getData();
            $("#editor").hide();
        }

        function loadData() {

           

            $.get("api/StaticPages?=about", {}, gotList, "json");

        }
        function setup() {

            loadData();
        }

        $(document).ready(setup);
    </script>


    
    
</asp:Content>
