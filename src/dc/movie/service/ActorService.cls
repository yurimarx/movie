Class dc.movie.service.ActorService Extends %CSP.REST
{

Parameter CHARSET = "utf-8";

Parameter CONVERTINPUTSTREAM = 1;

Parameter CONTENTTYPE = "application/json";

Parameter Version = "1.0.0";

Parameter HandleCorsRequest = 1;

/// Return all the records
ClassMethod GetAllActors() As %Status
{

    #dim tSC As %Status = $$$OK

    Set rset = ##class(dc.movie.model.Actor).ExtentFunc()

    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"
    
    Write "["
    
    if rset.%Next() {
        Set actor = ##class(dc.movie.model.Actor).%OpenId(rset.ID)    
        Do actor.%JSONExport()
    }
    
    While rset.%Next() {   
        Write "," 
        Set actor = ##class(dc.movie.model.Actor).%OpenId(rset.ID)    
        Do actor.%JSONExport()
    }

    Write "]"

    Quit tSC
}

/// Return one record
ClassMethod GetActor(id As %Integer) As %Status
{
	#dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException


    #; Set the response header to plain text
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"

    Set actor = ##class(dc.movie.model.Actor).%OpenId(id)

    If '$IsObject(actor) Quit ..Http404()

    Do actor.%JSONExport()

    Quit tSC
}

/// Creates a new record
ClassMethod CreateActor() As %Status
{
	
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    Set actor = ##class(dc.movie.model.Actor).%New()

    Set data = {}.%FromJSON(%request.Content)

    $$$TOE(tSC,actor.%JSONImport(data))
    $$$TOE(tSC,actor.%Save())

    Write actor.%JSONExport()

    Set %response.Status = 204
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"
    
    Quit tSC
}

/// Update a record with id
ClassMethod UpdateActor(id As %Integer) As %Status
{
	#dim tSC As %Status = $$$OK 
    #dim e As %Exception.AbstractException
    
    Set actor = ##class(dc.movie.model.Actor).%OpenId(id) 
    
    If '$IsObject(actor) Return ..Http404()
    
    Set data = {}.%FromJSON(%request.Content)

    $$$TOE(tSC,actor.%JSONImport(data))
    $$$TOE(tSC,actor.%Save())
    
    Write actor.%JSONExport()

    Set %response.Status = 200
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"

    Quit tSC
}

/// Delete a record with id
ClassMethod DeleteActor(id As %Integer) As %Status
{
	#dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    Set actor = ##class(dc.movie.model.Actor).%OpenId(id)
    
    If '$IsObject(actor) Return ..Http404()

    $$$TOE(tSC, actor.%DeleteId(id))

    Set %response.Status = 200

    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"

    Quit tSC
}

}
