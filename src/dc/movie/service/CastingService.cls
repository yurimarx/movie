Class dc.movie.service.CastingService Extends %CSP.REST
{

Parameter CHARSET = "utf-8";

Parameter CONVERTINPUTSTREAM = 1;

Parameter CONTENTTYPE = "application/json";

Parameter Version = "1.0.0";

Parameter HandleCorsRequest = 1;

/// Return all the records
ClassMethod GetAllCastings() As %Status
{

    #dim tSC As %Status = $$$OK

    Set rset = ##class(dc.movie.model.Casting).ExtentFunc()

    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"
    
    Write "["
    
    if rset.%Next() {
        Set casting = ##class(dc.movie.model.Casting).%OpenId(rset.ID)    
        Do casting.%JSONExport()
    }
    
    While rset.%Next() {   
        Write "," 
        Set casting = ##class(dc.movie.model.Casting).%OpenId(rset.ID)    
        Do casting.%JSONExport()
    }

    Write "]"

    Quit tSC
}

/// Return one record
ClassMethod GetCasting(id As %Integer) As %Status
{
	#dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException


    #; Set the response header to plain text
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"

    Set casting = ##class(dc.movie.model.Casting).%OpenId(id)

    If '$IsObject(casting) Quit ..Http404()

    Do casting.%JSONExport()

    Quit tSC
}

/// Creates a new record
ClassMethod CreateCasting() As %Status
{
	
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    Set casting = ##class(dc.movie.model.Casting).%New()

    Set data = {}.%FromJSON(%request.Content)

    $$$TOE(tSC,casting.%JSONImport(data))
    $$$TOE(tSC,casting.%Save())

    Write casting.%JSONExport()

    Set %response.Status = 204
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"
    
    Quit tSC
}

/// Update a record with id
ClassMethod UpdateCasting(id As %Integer) As %Status
{
	#dim tSC As %Status = $$$OK 
    #dim e As %Exception.AbstractException
    
    Set casting = ##class(dc.movie.model.Casting).%OpenId(id) 
    
    If '$IsObject(casting) Return ..Http404()
    
    Set data = {}.%FromJSON(%request.Content)

    $$$TOE(tSC,casting.%JSONImport(data))
    $$$TOE(tSC,casting.%Save())
    
    Write casting.%JSONExport()

    Set %response.Status = 200
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"

    Quit tSC
}

/// Delete a record with id
ClassMethod DeleteCasting(id As %Integer) As %Status
{
	#dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    Set casting = ##class(dc.movie.model.Casting).%OpenId(id)
    
    If '$IsObject(casting) Return ..Http404()

    $$$TOE(tSC, casting.%DeleteId(id))

    Set %response.Status = 200

    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"

    Quit tSC
}

}
