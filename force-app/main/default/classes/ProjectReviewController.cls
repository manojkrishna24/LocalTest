public class ProjectReviewController {
	
    Id projectReviewId;
    
    public ProjectReviewController(ApexPages.StandardController stdController) {
		projectReviewId = stdController.getId();
    }
    
    public void generateProjectReview() {
        ReviewGen.generateProjectReview(projectReviewId);
    }
}