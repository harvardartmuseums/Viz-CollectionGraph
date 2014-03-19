WITH list (objectid, classificationid) as
	(select distinct o.objectid, 
		(select classificationid from tms.dbo.Classifications where Classifications.Classification = o.Classification and Classifications.SubClassification is null) as ClassificationID
	FROM ArtPageViews a
	inner join tms.dbo.apiObjects o on a.objectid = o.ObjectID),
	
	clist (ClassificationID, Classification) as
	(SELECT DISTINCT ClassificationID, Classification
		FROM TMS.dbo.Classifications c
		WHERE c.Classification IN (SELECT DISTINCT Classification FROM TMS.dbo.apiObjects)
			AND c.SubClassification IS NULL)

SELECT CONVERT(VARCHAR(10), c.dt, 121) as StatsDate, class.*, 
		ISNULL((SELECT SUM(pageviews)
			FROM ArtPageViews a
			INNER JOIN list on a.ObjectID = list.objectid
			WHERE a.StatsDate = convert(varchar(10), c.dt, 121) and list.classificationid = class.ClassificationID
			GROUP BY statsdate, Classificationid), 0) AS PageViews
from tms.dbo.Calendar c
cross join (select ClassificationID, Classification, ROW_NUMBER() OVER (ORDER BY Classification) as Idx from clist) class
where c.dt between '2009-01-01' and '2014-12-31'
order by c.dt, class.Classification


