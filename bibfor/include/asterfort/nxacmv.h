!
! COPYRIGHT (C) 1991 - 2013  EDF R&D                WWW.CODE-ASTER.ORG
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
#include "asterf_types.h"
!
interface
    subroutine nxacmv(modele, mate, carele, fomult, charge,&
                      infcha, infoch, numedd, solveu, lostat,&
                      time, tpsthe, reasvc, reasvt, reasmt,&
                      reasrg, reasms, creas, vtemp, vhydr,&
                      tmpchi, tmpchf, vec2nd, vec2ni, matass,&
                      maprec, cndirp, cnchci, mediri, compor)
        character(len=24) :: modele
        character(len=24) :: mate
        character(len=24) :: carele
        character(len=24) :: fomult
        character(len=24) :: charge
        character(len=19) :: infcha
        character(len=24) :: infoch
        character(len=24) :: numedd
        character(len=19) :: solveu
        aster_logical :: lostat
        character(len=24) :: time
        real(kind=8) :: tpsthe(6)
        aster_logical :: reasvc
        aster_logical :: reasvt
        aster_logical :: reasmt
        aster_logical :: reasrg
        aster_logical :: reasms
        character(len=1) :: creas
        character(len=24) :: vtemp
        character(len=24) :: vhydr
        character(len=24) :: tmpchi
        character(len=24) :: tmpchf
        character(len=24) :: vec2nd
        character(len=24) :: vec2ni
        character(len=24) :: matass
        character(len=19) :: maprec
        character(len=24) :: cndirp
        character(len=24) :: cnchci
        character(len=24) :: mediri
        character(len=24) :: compor
    end subroutine nxacmv
end interface
