subroutine dtmclean(sd_dtm_)
    implicit none

!
! ======================================================================
! COPYRIGHT (C) 1991 - 2017  EDF R&D                  WWW.CODE-ASTER.ORG
! THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
! IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
! THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
! (AT YOUR OPTION) ANY LATER VERSION.
!
! THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
! WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
! MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
! GENERAL PUBLIC LICENSE FOR MORE DETAILS.
!
! YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
! ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
!    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
! ======================================================================
!
! person_in_charge: hassan.berro@edf.fr
!
! dtmclean : call all subroutines that need to be called to clean their
!            own data
!
!       sd_dtm_          : dtm data structure 
!       sd_nl_           : nl  data structure
!
! =======================================================================

#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/dtmget.h"
#include "asterfort/dtmclean_noli_lub.h"
#include "asterfort/dtmclean_noli_yacs.h"


!     1. Input / output arguments
      character(len=*)      , intent(in)  :: sd_dtm_
      character(len=8)                    :: sd_dtm, sd_nl

      integer                             :: nbnli


      call jemarq()

      sd_dtm = sd_dtm_

      call dtmget(sd_dtm, _NB_NONLI, iscal=nbnli)

      if(nbnli.gt.0) then

        call dtmget(sd_dtm, _SD_NONL  , kscal=sd_nl)

        call dtmclean_noli_lub(sd_dtm, sd_nl)

        call dtmclean_noli_yacs(sd_dtm, sd_nl)


      endif

    
      call jedema()



end subroutine