##[iOS] 펫팁 1.0

###PetTip iOS 가이드																

	1	대응 OS 버전																
		iOS 14																
																		
	2	언어, 프레임워크																
		Swift 5 + UIKit 																
																		
	3	구축시 사용한 Xcode 버전																
		15.0.1																
																		
	4	구축 기간																
		2023.11.20 ~ 2024.02.20																
																		
	5	사용 라이브러리																
		Alamofire			통신														
		AlamofireImage		이미지 통신														
		DGCharts			그래프, 챠트														
		DropDown			콤보박스														
		Firebase			FCM														
		FSPagerView			화면 좌/우 스와이프 이미지 뷰														
		Kakao				카카오 로그인														
		naveridlogin		네이버 로그인														
		NMapsMap			네이버 지도														
		Pageboy				Tabman 라이브러리에서 사용														
		RxSwift				RxSwift 구현에 사용														
		Tabman				상단 탭														
		Toaster				안드로이드 Toast 호환														
																		
	6	소스 인덱스																
		현재 사용되고 있는 코드만 기재합니다.																
		Popup																
			PopupModalViewController					팝업이 출력되는 화면 단위										
			CommonPopupView								팝업 뷰의 공통단										
			CommonConfirmView							확인 팝업 뷰										
			CommonModifyView							수정가능 팝업 뷰										
			CommentModifyView							커뮤니티 코멘트 팝업 뷰										
			ReportView									신고 팝업 뷰										
			DatePickerView								날짜일시 선택 팝업 뷰										
			SelectInvitePetView							초대 펫 선택 팝업 뷰										
			PetWeightView								펫 무게 입력 팝업 뷰										
			SelectWalkPetView							산책할 펫 선택 팝업 뷰										
			SelectWalkPetItemView						산책할 펫 선택 팝업 내 테이블 뷰 아이템										
			SelectWalkMarkPetView						다수 펫 데리고 산책 중 마커 표시할 때 마커할 펫 선택 팝업 뷰										
			SelectWalkMarkPetItemView					다수 펫 데리고 산책 중 마커 표시할 때 마커할 펫 선택 팝업 뷰의 테이블 뷰 아이템										
		Network																
			OAuth										로그인 oauth 인증 관련										
			Base										통신에 사용할 공통										
			API											API 통신 그룹별 Model, API 호출부, API 호출 관련 선언부										
			Domain										API에서 응답받은 컨텐츠 VO										
		Util																
			기능 별 사용되는 유틸성 기능															
		Page																
			Member															
				FindIdPwViewController					ID/비밀번호 찾기 화면										
				FindIdPwContainerViewController			ID/비밀번호 찾기 화면 탭에 대한 분리 화면 구축용 컨테이너										
				FindIdViewController					ID찾기 화면										
				FindPwViewController					비밀번호 찾기 화면										
				JoinViewController						회원가입 화면										
				SNSJoinViewcontrroller					SNS회원가입 화면										
				Member									Member 그룹 스토리보드										
			IntroViewController							인트로 화면										
			PermissionInfoViewController				권한안내 화면										
			LoginViewController							로그인 화면										
			MainViewController 							메인 화면										
			Common																
				CommonViewController					화면 공통 (모든 화면은 이 클래스를 확장하여 전개)										
				CommonDetailViewController				화면별 상세화면 구현시 사용할 공통										
				CommonDetailImageItemView				좌/우 스와이프 되는 이미지 뷰 공통										
				LogoTitleBarView						로고 이미지 있는 화면 상단 타이틀바										
				BackTitleBarView						뒤로가기 버튼 있는 화면 상단 타이틀바										
				ImageViewController						이미지 상세보기 화면										
				Common									Common 그룹 스토리보드										
			Home																
				SelectPetView							메인 화면에서 나의 반려동물 선택 뷰										
				SelectPetItemView						메인 화면에서 나의 반려동물 선택 뷰의 콜랙션 아이템 뷰										
				CompPetListView							메인 화면에서 반려동물 선택 뷰										
				CompPetListItemView						메인 화면에서 반려동물 선택 뷰의 테이블 아이템 뷰										
				PetProfItemView							펫 프로파일 이미지 공통 뷰										
				HomeStoryItemView						메인화면 스토리 콜랙션 아이템 뷰										
			WalkHistory																
				WalkHistoryViewController				산책기록 주간 화면										
				WalkHistoryDetailViewController			산책기록 상세 화면										
				WalkHistroryItemView					산책기록 주간/월간 날짜별 표시용 뷰										
				WalkHistoryWeekListItemView				산책기록 주간 표시 테이블 아이템 뷰										
				WalkHistoryPetItemView					산책기록 펫 별 아이템 뷰										
				WalkHistoryMonthView 					산책기록 주간 화면에 띄울 월간 화면 뷰										
			Community															
				CommunityViewController					커뮤니티 화면										
				CommunityContainerViewController		커뮤니티 화면 탭에 대한 분리 화면 구축용 컨테이너										
				StoryListViewController					스토리 목록 화면										
				StoryDetailViewController				스토리 상세 화면										
				StoryItemView							스토리 목록 아이템 뷰										
				CommunityCommentView					스토리 상세화면 코멘트 뷰										
				EventListViewController					이벤트 목록 화면										
				EventDetailViewController				이벤트 상세 화면										
				AncmntListItemView						이벤트 목록 테이블 아이템 뷰										
				AncmntWinnerDetailViewController		당첨자 발표 상세 화면										
				StoryAddViewController					스토리 등록 화면										
				DailyLifeGubunItemView					일상 구분 아이템 뷰										
				StoryModifyViewController				스토리 수정 화면										
				Community								Community 그룹 스토리보드										
			MyPage															
				MyPageViewController					마이페이지 화면										
				MyPageCompPetListItemView				내 펫 목록 아이템 뷰										
				MyPageCompPetListEmptyItemView			내 펫 목록 비어있을 때 표시용 뷰										
				UserInfoViewController					사용자 정보 화면										
				InviteCreateViewController				초대하기 화면										
				InviteSetKetViewController 				초대용 키 입력 화면										
				PetAddViewController					펫 등록 화면										
				PetTypeSelectViewController				펫 종류 선택 화면										
				AddressSelectViewController				펫 주소 선택 화면										
				CustomerCenterViewController			고객센터 화면										
				CustomerCenterContainerViewController	고객센터 화면 탭에 대한 분리 화면 구축용 컨테이너										
				NoticeViewController					공지사항 화면										
				NoticeListItemView						공지사항 목록 아이템 뷰										
				NoticeDetailViewController				공지사항 상세 화면										
				FaqViewController						FAQ 화면										
				FaqListItemView							FAQ 목록 아이템 뷰										
				QnAListItemView							Q&A 목록 아이템 뷰										
				QnADetailViewController					Q&A 상세 화면										
				QnADetailAttachFileItemView				Q&A 상세화면 파일 뷰										
				QnAModifyViewController					Q&A 수정 화면										
				QnAModiftAttachFileItemView				Q&A 수정 화면 파일 뷰										
				PetProfleViewController					펫 정보 화면										
				PetProfileMemberItemView				펫 관리 맴버 목록 아이템 뷰										
				PetModiftViewController					펫 수정 화면										
				MyPage									MyPage 그룹 스토리보드										
				Pet										Pet 그룹 스토리보드										
				CustomerCenter							CustomerCenter 그룹 스토리보드										
			Map															
				NMapViewController						산책 지도 화면 : 네이버지도										
				LocationViewController					현재 위치 수신 : NMapViewController이 이 클래스를 확장 구현함										
				MapTopView								지도 상단 뷰										
				MapTipView								지도 상단 뷰 내의 팁 뷰										
				Track									경로 저장 구조										
				MapBottomView							지도 하단표시 뷰 : 산책 종료 확인 뷰										
				PostViewController						산책 내용 등록 화면										
				Map										Map 그룹 스토리보드										
		AppDelegate										앱 루트부 (안드로이드의 Application 클래스와 흡사)										
		Global											앱 설정 내역 정의, 공통 사용 데이터 보관										
		Assets											이미지 리소스 목록 정의										
		LaunchScreen									앱 최초 기동 화면										
																		
	7	연결 서버 변경																
		Global 파일에 선언된 DOMAIN을 변경																
																		
	8	타임라인 화면 생성 가이드																
		1. Storyboard에 타임라인 UIViewController 생성 후, 타 화면 UIViewController에서 올 수 있도록 연결 																
		2. 상단에 타이틀바 UIView 에 UILabel 가운데 정렬로 타이틀명 표시																
		3. 그 아래 컨텐츠 뷰는 UITableView로 꽉 채우고 Constraint 설정																
		4. UITableView 내 컨텐츠는 UITableViewCell로 만드는데, 커스컴 형태의 셀을 만들어야 하므로 UITableViewCell을 extends 한 커스텀 뷰와 이 뷰에 대한 XIB를 생성해서 구현																
		5. Cell 내에 표시할 컨텐츠에 대해, 문자열은 UILabel, 이미지는 UIImageView, 선은 UIView를 사용하여 XIB 상에 전개 																
		6. 배치한 View 각각의 컴퓨넌트들의 위치나 제약조건을 NSLayoutConstraint로 설정																
		7. 타임라인에 대한 통신 (기존 타 통신부 참고)해서 데이터 받아온 후, 받아온 데이터를 UITableViewDelegate 부분에 테이블 표시형태로 가공하여 넘기고 테이블 뷰 갱신																
																		
	9	기타																
		Git에 최종 push한 내역에 앱 버전이 0.1로 되어 있습니다. 이는 실배포가 아닌 테스트배포(TestFlight)를 위해 임시로 내려둔 것입니다.																
		실배포시 1.0으로 변경하여 심사요청 해주시기 바랍니다.																
		실배포에 필요한 내역 중 스크린샷, 가격정보, 연령정보, 테스트 계정 등의 정보는 이미 기입해놨습니다.																
		하지만, 앱 정보나, 카피라이트 등 일부 기입이 덜 된 내역이 있으므로, 이 내역 중 필수가 되는 내역은 반드시 기입 후 심사요청을 하셔야 합니다.																
