subroutine as_mmhgnr(fid, nomail, typent, typgeo, tblogl,&
                     n, cret)
! person_in_charge: nicolas.sellenet at edf.fr
!
! COPYRIGHT (C) 1991 - 2019  EDF R&D                WWW.CODE-ASTER.ORG
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
#include "asterf_config.h"
#include "asterf_types.h"
#include "asterfort/conv_int.h"
#include "med/mmhgnr.h"
    med_idt :: fid
    aster_int :: typent, typgeo, n, cret, numdt, numo
    aster_int :: tblogl(n)
    character(len=*) :: nomail
#ifdef _DISABLE_MED
    call u2mess('F', 'FERMETUR_2')
#else

#if med_int_kind != aster_int_kind || med_idt_kind != aster_int_kind
    med_idt :: fid4
    med_int :: typen4, typge4, cret4, numdt4, numo4
    med_int, allocatable :: tblog4(:)

    fid4 = to_med_idt(fid)
    numdt4 = -1
    numo4 = -1
    typen4 = to_med_int(typent)
    typge4 = to_med_int(typgeo)
    allocate ( tblog4(n) )

    call mmhgnr(fid4, nomail, numdt4, numo4, typen4,&
                typge4, tblog4, cret4)

    call conv_int('med->ast', n, vi_ast=tblogl, vi_med=tblog4)
    cret = to_aster_int(cret4)
    deallocate (tblog4)
#else
    call mmhgnr(fid, nomail, -1, -1, typent,&
                typgeo, tblogl, cret)
#endif

#endif
end subroutine
