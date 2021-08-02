Class dc.movie.service.MovieCategoryService Extends %CSP.REST
{

Parameter CHARSET = "utf-8";

Parameter CONVERTINPUTSTREAM = 1;

Parameter CONTENTTYPE = "application/json";

Parameter Version = "1.0.0";

Parameter HandleCorsRequest = 1;

/// Return all the records
ClassMethod GetAllMovieCategories() As %Status
{

    #dim tSC As %Status = $$$OK

    Set rset = ##class(dc.movie.model.MovieCategory).ExtentFunc()

    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"
    
    Write "["
    
    if rset.%Next() {
        Set movieCategory = ##class(dc.movie.model.MovieCategory).%OpenId(rset.ID)    
        Do movieCategory.%JSONExport()
    }
    
    While rset.%Next() {   
        Write "," 
        Set movieCategory = ##class(dc.movie.model.MovieCategory).%OpenId(rset.ID)    
        Do movieCategory.%JSONExport()
    }

    Write "]"

    Quit tSC
}

/// Return one record
ClassMethod GetMovieCategory(id As %Integer) As %Status
{
	#dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException


    #; Set the response header to plain text
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"

    Set movieCategory = ##class(dc.movie.model.MovieCategory).%OpenId(id)

    If '$IsObject(movieCategory) Quit ..Http404()

    Do movieCategory.%JSONExport()

    Quit tSC
}

/// Creates a new record
ClassMethod CreateMovieCategory() As %Status
{
	
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    Set movieCategory = ##class(dc.movie.model.MovieCategory).%New()

    Set data = {}.%FromJSON(%request.Content)

    $$$TOE(tSC,movieCategory.%JSONImport(data))
    $$$TOE(tSC,movieCategory.%Save())

    Write movieCategory.%JSONExport()

    Set %response.Status = 204
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"
    
    Quit tSC
}

/// Update a record with id
ClassMethod UpdateMovieCategory(id As %Integer) As %Status
{
	#dim tSC As %Status = $$$OK 
    #dim e As %Exception.AbstractException
    
    Set movieCategory = ##class(dc.movie.model.MovieCategory).%OpenId(id) 
    
    If '$IsObject(movieCategory) Return ..Http404()
    
    Set data = {}.%FromJSON(%request.Content)

    $$$TOE(tSC,movieCategory.%JSONImport(data))
    $$$TOE(tSC,movieCategory.%Save())
    
    Write movieCategory.%JSONExport()

    Set %response.Status = 200
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"

    Quit tSC
}

/// Delete a record with id
ClassMethod DeleteMovieCategory(id As %Integer) As %Status
{
	#dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    Set movieCategory = ##class(dc.movie.model.MovieCategory).%OpenId(id)
    
    If '$IsObject(movieCategory) Return ..Http404()

    $$$TOE(tSC, movieCategory.%DeleteId(id))

    Set %response.Status = 200

    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"

    Quit tSC
}

}
