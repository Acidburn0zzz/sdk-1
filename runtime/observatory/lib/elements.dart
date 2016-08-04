library observatory_elements;

// Export elements.
export 'package:observatory/src/elements/action_link.dart';
export 'package:observatory/src/elements/class_ref_as_value.dart';
export 'package:observatory/src/elements/class_tree.dart';
export 'package:observatory/src/elements/class_view.dart';
export 'package:observatory/src/elements/code_view.dart';
export 'package:observatory/src/elements/context_ref.dart';
export 'package:observatory/src/elements/context_view.dart';
export 'package:observatory/src/elements/cpu_profile.dart';
export 'package:observatory/src/elements/debugger.dart';
export 'package:observatory/src/elements/error_view.dart';
export 'package:observatory/src/elements/eval_box.dart';
export 'package:observatory/src/elements/eval_link.dart';
export 'package:observatory/src/elements/field_ref.dart';
export 'package:observatory/src/elements/field_view.dart';
export 'package:observatory/src/elements/flag_list.dart';
export 'package:observatory/src/elements/function_view.dart';
export 'package:observatory/src/elements/heap_map.dart';
export 'package:observatory/src/elements/heap_profile.dart';
export 'package:observatory/src/elements/heap_snapshot.dart';
export 'package:observatory/src/elements/icdata_view.dart';
export 'package:observatory/src/elements/instance_ref.dart';
export 'package:observatory/src/elements/instance_view.dart';
export 'package:observatory/src/elements/instructions_view.dart';
export 'package:observatory/src/elements/io_view.dart';
export 'package:observatory/src/elements/isolate_reconnect.dart';
export 'package:observatory/src/elements/isolate_summary.dart';
export 'package:observatory/src/elements/isolate_view.dart';
export 'package:observatory/src/elements/json_view.dart';
export 'package:observatory/src/elements/library_ref_as_value.dart';
export 'package:observatory/src/elements/library_view.dart';
export 'package:observatory/src/elements/logging.dart';
export 'package:observatory/src/elements/megamorphiccache_view.dart';
export 'package:observatory/src/elements/metrics.dart';
export 'package:observatory/src/elements/object_common.dart';
export 'package:observatory/src/elements/object_view.dart';
export 'package:observatory/src/elements/objectpool_view.dart';
export 'package:observatory/src/elements/objectstore_view.dart';
export 'package:observatory/src/elements/observatory_application.dart';
export 'package:observatory/src/elements/observatory_element.dart';
export 'package:observatory/src/elements/persistent_handles.dart';
export 'package:observatory/src/elements/ports.dart';
export 'package:observatory/src/elements/script_inset.dart';
export 'package:observatory/src/elements/script_view.dart';
export 'package:observatory/src/elements/service_ref.dart';
export 'package:observatory/src/elements/service_view.dart';
export 'package:observatory/src/elements/timeline_page.dart';
export 'package:observatory/src/elements/vm_connect.dart';
export 'package:observatory/src/elements/vm_view.dart';

import 'dart:async';

import 'package:observatory/src/elements/class_ref.dart';
import 'package:observatory/src/elements/class_ref_wrapper.dart';
import 'package:observatory/src/elements/code_ref.dart';
import 'package:observatory/src/elements/code_ref_wrapper.dart';
import 'package:observatory/src/elements/containers/virtual_collection.dart';
import 'package:observatory/src/elements/containers/virtual_tree.dart';
import 'package:observatory/src/elements/curly_block.dart';
import 'package:observatory/src/elements/curly_block_wrapper.dart';
import 'package:observatory/src/elements/error_ref.dart';
import 'package:observatory/src/elements/error_ref_wrapper.dart';
import 'package:observatory/src/elements/function_ref.dart';
import 'package:observatory/src/elements/function_ref_wrapper.dart';
import 'package:observatory/src/elements/general_error.dart';
import 'package:observatory/src/elements/isolate_ref.dart';
import 'package:observatory/src/elements/isolate_ref_wrapper.dart';
import 'package:observatory/src/elements/library_ref.dart';
import 'package:observatory/src/elements/library_ref_wrapper.dart';
import 'package:observatory/src/elements/nav/bar.dart';
import 'package:observatory/src/elements/nav/class_menu.dart';
import 'package:observatory/src/elements/nav/class_menu_wrapper.dart';
import 'package:observatory/src/elements/nav/isolate_menu.dart';
import 'package:observatory/src/elements/nav/isolate_menu_wrapper.dart';
import 'package:observatory/src/elements/nav/library_menu.dart';
import 'package:observatory/src/elements/nav/library_menu_wrapper.dart';
import 'package:observatory/src/elements/nav/menu.dart';
import 'package:observatory/src/elements/nav/menu_wrapper.dart';
import 'package:observatory/src/elements/nav/menu_item.dart';
import 'package:observatory/src/elements/nav/menu_item_wrapper.dart';
import 'package:observatory/src/elements/nav/notify.dart';
import 'package:observatory/src/elements/nav/notify_wrapper.dart';
import 'package:observatory/src/elements/nav/notify_event.dart';
import 'package:observatory/src/elements/nav/notify_exception.dart';
import 'package:observatory/src/elements/nav/refresh.dart';
import 'package:observatory/src/elements/nav/refresh_wrapper.dart';
import 'package:observatory/src/elements/nav/top_menu.dart';
import 'package:observatory/src/elements/nav/top_menu_wrapper.dart';
import 'package:observatory/src/elements/nav/vm_menu.dart';
import 'package:observatory/src/elements/nav/vm_menu_wrapper.dart';
import 'package:observatory/src/elements/script_ref.dart';
import 'package:observatory/src/elements/script_ref_wrapper.dart';
import 'package:observatory/src/elements/source_link.dart';
import 'package:observatory/src/elements/source_link_wrapper.dart';
import 'package:observatory/src/elements/view_footer.dart';
import 'package:observatory/src/elements/vm_connect_target.dart';
import 'package:observatory/src/elements/vm_connect.dart';

export 'package:observatory/src/elements/helpers/rendering_queue.dart';

export 'package:observatory/src/elements/class_ref.dart';
export 'package:observatory/src/elements/code_ref.dart';
export 'package:observatory/src/elements/containers/virtual_collection.dart';
export 'package:observatory/src/elements/containers/virtual_tree.dart';
export 'package:observatory/src/elements/curly_block.dart';
export 'package:observatory/src/elements/error_ref.dart';
export 'package:observatory/src/elements/function_ref.dart';
export 'package:observatory/src/elements/general_error.dart';
export 'package:observatory/src/elements/isolate_ref.dart';
export 'package:observatory/src/elements/library_ref.dart';
export 'package:observatory/src/elements/nav/bar.dart';
export 'package:observatory/src/elements/nav/class_menu.dart';
export 'package:observatory/src/elements/nav/isolate_menu.dart';
export 'package:observatory/src/elements/nav/library_menu.dart';
export 'package:observatory/src/elements/nav/menu.dart';
export 'package:observatory/src/elements/nav/menu_item.dart';
export 'package:observatory/src/elements/nav/notify.dart';
export 'package:observatory/src/elements/nav/notify_event.dart';
export 'package:observatory/src/elements/nav/notify_exception.dart';
export 'package:observatory/src/elements/nav/refresh.dart';
export 'package:observatory/src/elements/nav/top_menu.dart';
export 'package:observatory/src/elements/nav/vm_menu.dart';
export 'package:observatory/src/elements/script_ref.dart';
export 'package:observatory/src/elements/source_link.dart';
export 'package:observatory/src/elements/view_footer.dart';
export 'package:observatory/src/elements/vm_connect_target.dart';
export 'package:observatory/src/elements/vm_connect.dart';

// Even though this function does not invoke any asynchronous operation
// it is marked as async to allow future backward compatible changes.
Future initElements() async {
  ClassRefElement.tag.ensureRegistration();
  ClassRefElementWrapper.tag.ensureRegistration();
  CodeRefElement.tag.ensureRegistration();
  CodeRefElementWrapper.tag.ensureRegistration();
  CurlyBlockElement.tag.ensureRegistration();
  CurlyBlockElementWrapper.tag.ensureRegistration();
  ErrorRefElement.tag.ensureRegistration();
  ErrorRefElementWrapper.tag.ensureRegistration();
  FunctionRefElement.tag.ensureRegistration();
  FunctionRefElementWrapper.tag.ensureRegistration();
  GeneralErrorElement.tag.ensureRegistration();
  IsolateRefElement.tag.ensureRegistration();
  IsolateRefElementWrapper.tag.ensureRegistration();
  LibraryRefElement.tag.ensureRegistration();
  LibraryRefElementWrapper.tag.ensureRegistration();
  NavBarElement.tag.ensureRegistration();
  NavClassMenuElement.tag.ensureRegistration();
  NavClassMenuElementWrapper.tag.ensureRegistration();
  NavIsolateMenuElement.tag.ensureRegistration();
  NavIsolateMenuElementWrapper.tag.ensureRegistration();
  NavLibraryMenuElement.tag.ensureRegistration();
  NavLibraryMenuElementWrapper.tag.ensureRegistration();
  NavMenuElement.tag.ensureRegistration();
  NavMenuElementWrapper.tag.ensureRegistration();
  NavMenuItemElement.tag.ensureRegistration();
  NavMenuItemElementWrapper.tag.ensureRegistration();
  NavNotifyElement.tag.ensureRegistration();
  NavNotifyElementWrapper.tag.ensureRegistration();
  NavNotifyEventElement.tag.ensureRegistration();
  NavNotifyExceptionElement.tag.ensureRegistration();
  NavRefreshElement.tag.ensureRegistration();
  NavRefreshElementWrapper.tag.ensureRegistration();
  NavTopMenuElement.tag.ensureRegistration();
  NavTopMenuElementWrapper.tag.ensureRegistration();
  NavVMMenuElement.tag.ensureRegistration();
  NavVMMenuElementWrapper.tag.ensureRegistration();
  ScriptRefElement.tag.ensureRegistration();
  ScriptRefElementWrapper.tag.ensureRegistration();
  SourceLinkElement.tag.ensureRegistration();
  SourceLinkElementWrapper.tag.ensureRegistration();
  ViewFooterElement.tag.ensureRegistration();
  VirtualCollectionElement.tag.ensureRegistration();
  VirtualTreeElement.tag.ensureRegistration();
  VMConnectElement.tag.ensureRegistration();
  VMConnectTargetElement.tag.ensureRegistration();
}
