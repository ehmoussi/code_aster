subroutine pmfinfo(nbfibr,nbgrfi,tygrfi,nbcarm,nug,jacf,nbassfi)
!
! ======================================================================
! COPYRIGHT (C) 1991 - 2015  EDF R&D                  WWW.CODE-ASTER.ORG
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
! --------------------------------------------------------------------------------------------------
!
!           Informations sur les PMF
!
! person_in_charge: jean-luc.flejou at edf.fr
! --------------------------------------------------------------------------------------------------
!
!   OUT
!       nbfibr      : nombre total de fibre
!       nbgrfi      : nombre de groupe de fibres
!       tygrfi      : type des groupes de fibres
!       nbcarm      : nombre de composantes dans la carte
!       nug         : numéro des groupes de fibres nug(1:nbgrfi)
!       jacf        : pointeur sur les caractéristiques de fibres
!       nbassfi     : nombre d'assemblage de fibre
! --------------------------------------------------------------------------------------------------
!
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jevech.h"
#include "asterfort/utmess.h"
!
    integer, intent(out) :: nbfibr, nbgrfi, tygrfi, nbcarm, nug(*)
    integer, intent(out),optional :: jacf, nbassfi
!
! --------------------------------------------------------------------------------------------------
!
    integer :: jnbspi, ii, numgr, jacf_loc
!
! --------------------------------------------------------------------------------------------------
!
    call jevech('PNBSP_I', 'L', jnbspi)
    nbfibr = zi(jnbspi)
    nbgrfi = zi(jnbspi+1)
    tygrfi = zi(jnbspi+2)
    nbcarm = zi(jnbspi+3)
    nug(1:nbgrfi) = zi(jnbspi+3+1:jnbspi+3+nbgrfi)
!
    if ( tygrfi .eq. 1 ) then
        if ( present(jacf) ) then
            call jevech('PFIBRES', 'L', jacf)
        endif
        if ( present(nbassfi) ) then
            nbassfi = 1
        endif
    else if ( tygrfi .eq. 2 ) then
        if ( present(jacf) ) then
            call jevech('PFIBRES', 'L', jacf_loc)
            jacf = jacf_loc
        endif
        if ( present(nbassfi) ) then
            if ( absent(jacf) ) then
                call jevech('PFIBRES', 'L', jacf_loc)
            endif
            nbassfi = 0
            do ii = 1 , nbfibr
                numgr = nint( zr(jacf_loc - 1 + ii*nbcarm) )
                nbassfi = max( nbassfi , numgr )
            enddo
            ASSERT( nbassfi .ne. 0 )
        endif
    else
        call utmess('F', 'ELEMENTS2_40', si=tygrfi)
    endif
end subroutine
