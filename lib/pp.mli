(************************************************************************)
(*  v      *   The Coq Proof Assistant  /  The Coq Development Team     *)
(* <O___,, *   INRIA - CNRS - LIX - LRI - PPS - Copyright 1999-2016     *)
(*   \VV/  **************************************************************)
(*    //   *      This file is distributed under the terms of the       *)
(*         *       GNU Lesser General Public License Version 2.1        *)
(************************************************************************)

(** Coq document type. *)

(* XXX: Improve and add attributes *)
type pp_tag = string list

type block_type =
  | Pp_hbox   of int
  | Pp_vbox   of int
  | Pp_hvbox  of int
  | Pp_hovbox of int

type std_ppcmds =
  | Ppcmd_empty
  | Ppcmd_string of string
  | Ppcmd_glue of std_ppcmds list
  | Ppcmd_box  of block_type * std_ppcmds
  | Ppcmd_print_break of int * int
  | Ppcmd_white_space of int
  | Ppcmd_force_newline
  | Ppcmd_open_box of block_type
  | Ppcmd_close_box
  | Ppcmd_open_tag of pp_tag
  | Ppcmd_close_tag

(** {6 Formatting commands} *)

val str   : string -> std_ppcmds
val brk   : int * int -> std_ppcmds
val fnl   : unit -> std_ppcmds
val ws    : int -> std_ppcmds
val mt    : unit -> std_ppcmds
val ismt  : std_ppcmds -> bool

val comment  : string list -> std_ppcmds

(** {6 Manipulation commands} *)

val app : std_ppcmds -> std_ppcmds -> std_ppcmds
(** Concatenation. *)

val (++) : std_ppcmds -> std_ppcmds -> std_ppcmds
(** Infix alias for [app]. *)

(** {6 Derived commands} *)

val spc : unit -> std_ppcmds
val cut : unit -> std_ppcmds
val align : unit -> std_ppcmds
val int : int -> std_ppcmds
val real : float -> std_ppcmds
val bool : bool -> std_ppcmds
val qstring : string -> std_ppcmds
val qs : string -> std_ppcmds
val quote : std_ppcmds -> std_ppcmds
val strbrk : string -> std_ppcmds

(** {6 Boxing commands} *)

val h : int -> std_ppcmds -> std_ppcmds
val v : int -> std_ppcmds -> std_ppcmds
val hv : int -> std_ppcmds -> std_ppcmds
val hov : int -> std_ppcmds -> std_ppcmds

(** {6 Opening and closing of boxes} *)

val hb : int -> std_ppcmds
val vb : int -> std_ppcmds
val hvb : int -> std_ppcmds
val hovb : int -> std_ppcmds
val close : unit -> std_ppcmds

(** {6 Opening and closing of tags} *)

val tag : pp_tag -> std_ppcmds -> std_ppcmds
val open_tag : pp_tag -> std_ppcmds
val close_tag : unit -> std_ppcmds

(** {6 Printing combinators} *)

val pr_comma : unit -> std_ppcmds
(** Well-spaced comma. *)

val pr_semicolon : unit -> std_ppcmds
(** Well-spaced semicolon. *)

val pr_bar : unit -> std_ppcmds
(** Well-spaced pipe bar. *)

val pr_arg : ('a -> std_ppcmds) -> 'a -> std_ppcmds
(** Adds a space in front of its argument. *)

val pr_non_empty_arg : ('a -> std_ppcmds) -> 'a -> std_ppcmds
(** Adds a space in front of its argument if non empty. *)

val pr_opt : ('a -> std_ppcmds) -> 'a option -> std_ppcmds
(** Inner object preceded with a space if [Some], nothing otherwise. *)

val pr_opt_no_spc : ('a -> std_ppcmds) -> 'a option -> std_ppcmds
(** Same as [pr_opt] but without the leading space. *)

val pr_nth : int -> std_ppcmds
(** Ordinal number with the correct suffix (i.e. "st", "nd", "th", etc.). *)

val prlist : ('a -> std_ppcmds) -> 'a list -> std_ppcmds
(** Concatenation of the list contents, without any separator.

    Unlike all other functions below, [prlist] works lazily. If a strict
    behavior is needed, use [prlist_strict] instead. *)

val prlist_strict :  ('a -> std_ppcmds) -> 'a list -> std_ppcmds
(** Same as [prlist], but strict. *)

val prlist_with_sep :
   (unit -> std_ppcmds) -> ('a -> std_ppcmds) -> 'a list -> std_ppcmds
(** [prlist_with_sep sep pr [a ; ... ; c]] outputs
    [pr a ++ sep() ++ ... ++ sep() ++ pr c]. *)

val prvect : ('a -> std_ppcmds) -> 'a array -> std_ppcmds
(** As [prlist], but on arrays. *)

val prvecti : (int -> 'a -> std_ppcmds) -> 'a array -> std_ppcmds
(** Indexed version of [prvect]. *)

val prvect_with_sep :
   (unit -> std_ppcmds) -> ('a -> std_ppcmds) -> 'a array -> std_ppcmds
(** As [prlist_with_sep], but on arrays. *)

val prvecti_with_sep :
   (unit -> std_ppcmds) -> (int -> 'a -> std_ppcmds) -> 'a array -> std_ppcmds
(** Indexed version of [prvect_with_sep]. *)

val pr_enum : ('a -> std_ppcmds) -> 'a list -> std_ppcmds
(** [pr_enum pr [a ; b ; ... ; c]] outputs
    [pr a ++ str "," ++ pr b ++ str "," ++ ... ++ str "and" ++ pr c]. *)

val pr_sequence : ('a -> std_ppcmds) -> 'a list -> std_ppcmds
(** Sequence of objects separated by space (unless an element is empty). *)

val surround : std_ppcmds -> std_ppcmds
(** Surround with parenthesis. *)

val pr_vertical_list : ('b -> std_ppcmds) -> 'b list -> std_ppcmds

val pr_loc : Loc.t -> std_ppcmds

(** {6 Main renderers, to formatter and to string } *)

(** FIXME: These ignore the logging settings and call [Format] directly *)
type tag_handler = pp_tag -> Format.tag

(** [msg_with fmt pp] Print [pp] to [fmt] and don't flush [fmt]  *)
val pp_with          : ?pp_tag:tag_handler -> Format.formatter -> std_ppcmds -> unit
val string_of_ppcmds : ?pp_tag:tag_handler -> std_ppcmds -> string
