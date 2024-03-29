package tl.utils
{
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;

	/**
	 * Scan passed Object or Class for members with metatag
	 * @param instanceOrClass	Object or Class to scan
	 * @param metatag			Metatag to scan
	 * @param fromFactory		if true, will scan "factory" property of object description instead of itself
	 * @return	Array of <code>tl.utils.MemberDescription</code>
	 */
	public function getMethodsWithMetadata( instanceOrClass : *, metatag : String, fromFactory : Boolean = false ) : Array
	{
		if ( instanceOrClass == null || instanceOrClass == "" ) return [];
		if ( metatag == null || metatag == "" ) return [];

		var cacheArray : Dictionary = instanceOrClass is Class ? classCache : objectCache;

		var key : * = instanceOrClass is Class ? instanceOrClass : instanceOrClass.constructor;

		var cachedMethods : Array = cacheArray[key];

		if ( cachedMethods == null )
		{
			cachedMethods = cacheArray[key] = [];

			var desc : XML = describeTypeCached( instanceOrClass );

			if ( fromFactory )
			{
				desc.factory.method.(valueOf().metadata.(@name == metatag).length()).(
						cachedMethods.push( new MemberDescription( String( @uri ), String( @name ), metadata.(@name == metatag) ) )
						);
			} else
			{
				desc.method.(valueOf().metadata.(@name == metatag).length()).(
						cachedMethods.push( new MemberDescription( String( @uri ), String( @name ), metadata.(@name == metatag) ) )
						);

				desc.extendsClass.(
						cachedMethods = cachedMethods.concat( getMethodsWithMetadata( getDefinitionByName( String( @type ) ), metatag, true ) )
						);
			}
		}

		return cachedMethods;
	}
}

import flash.utils.Dictionary;

const classCache : Dictionary = new Dictionary();
const objectCache : Dictionary = new Dictionary();