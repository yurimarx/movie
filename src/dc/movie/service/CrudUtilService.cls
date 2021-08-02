Class dc.movie.service.CrudUtilService Extends %CSP.REST
{

Parameter CHARSET = "utf-8";

Parameter CONVERTINPUTSTREAM = 1;

Parameter CONTENTTYPE = "application/json";

Parameter Version = "1.0.0";

Parameter HandleCorsRequest = 1;

/// Return all the records
ClassMethod GetAll(DomainClass As %Persistent) As %Status
{

    #dim tSC As %Status = $$$OK

    Set rset = DomainClass.ExtentFunc()

    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"
    
    Write "["
    
    if rset.%Next() {
        Set actor = DomainClass.%OpenId(rset.ID)    
        Do actor.%JSONExport()
    }
    
    While rset.%Next() {   
        Write "," 
        Set actor = DomainClass.%OpenId(rset.ID)    
        Do actor.%JSONExport()
    }

    Write "]"

    Quit tSC
}

/// Return one record
ClassMethod GetOne(DomainClass As %Persistent, id As %Integer) As %Status
{
	#dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException

    #; Set the response header to plain text
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"

    Set domain = DomainClass.%OpenId(id)

    If '$IsObject(domain) Quit ..Http404()

    Do domain.%JSONExport()

    Quit tSC
}

/// Creates a new record
ClassMethod Create(DomainClass As %Persistent) As %Status
{
	
    #dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    Set domain = DomainClass.%New()

    Set data = {}.%FromJSON(%request.Content)

    $$$TOE(tSC, domain.%JSONImport(data))
    $$$TOE(tSC, domain.%Save())

    Write domain.%JSONExport()

    Set %response.Status = 204
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"
    
    Quit tSC
}

/// Update a record with id
ClassMethod Update(DomainClass As %Persistent, id As %Integer) As %Status
{
	#dim tSC As %Status = $$$OK 
    #dim e As %Exception.AbstractException
    
    Set domain = DomainClass.%OpenId(id) 
    
    If '$IsObject(domain) Return ..Http404()
    
    Set data = {}.%FromJSON(%request.Content)

    $$$TOE(tSC, domain.%JSONImport(data))
    $$$TOE(tSC, domain.%Save())
    
    Write domain.%JSONExport()

    Set %response.Status = 200
    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"

    Quit tSC
}

/// Delete a record with id
ClassMethod Delete(DomainClass As %Persistent, id As %Integer) As %Status
{
	#dim tSC As %Status = $$$OK
    #dim e As %Exception.AbstractException
    
    Set domain = DomainClass.%OpenId(id)
    
    If '$IsObject(domain) Return ..Http404()

    $$$TOE(tSC, domain.%DeleteId(id))

    Set %response.Status = 200

    Set %response.ContentType = ..#CONTENTTYPEJSON
    Set %response.Headers("Access-Control-Allow-Origin")="*"

    Quit tSC
}

}
