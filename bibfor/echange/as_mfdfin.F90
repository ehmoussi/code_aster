subroutine as_mfdfin(fid, cha, ma, n, cunit,&
                     cname, cret)
! person_in_charge: nicolas.sellenet at edf.fr
!
! COPYRIGHT (C) 1991 - 2017  EDF R&D                WWW.CODE-ASTER.ORG
!
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
! 1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
!
    implicit none
#include "asterf_types.h"
#include "asterf.h"
#include "asterfort/utmess.h"
#include "med/mfioex.h"
#include "med/mfdfin.h"
    aster_int :: fid, n, cret
    character(len=*) :: cha
    character(len=16) :: cunit, cname
    character(len=*) :: ma
    character(len=80) :: dtunit
#ifdef _DISABLE_MED
    call utmess('F', 'FERMETUR_2')
#else
!
#if med_int_kind != aster_int_kind
    med_int :: fid4, n4, cret4, lmesh4, typen4
    med_int :: oexist4, class4
    fid4 = fid
    ! class4 = 1 <=> field type
    class4 = 1_4 
    ! On verifie que le champ existe bien avant d'appeler mfdfin
    ! pour eviter les "Erreur à l'ouverture du groupe" dans MED
    call mfioex(fid4, class4, cha, oexist4, cret4)
    if (oexist4.eq.1) then
        call mfdfin(fid4, cha, ma, lmesh4, typen4,&
                    cunit, cname, dtunit, n4, cret4)
        n = n4
        cret = cret4
    else
        n = 0
        cret = -1
    endif

#else
    aster_int :: lmesh, typen
    aster_int :: oexist, class
    ! class = 1 <=> field type
    class = 1
    ! On verifie que le champ existe bien avant d'appeler mfdfin
    ! pour eviter les "Erreur à l'ouverture du groupe" dans MED
    call mfioex(fid, class, cha, oexist, cret)
    if (oexist.eq.1) then
        call mfdfin(fid, cha, ma, lmesh, typen,&
                    cunit, cname, dtunit, n, cret)
    else
        n = 0
        cret = -1
    endif
#endif
!
#endif
end subroutine
